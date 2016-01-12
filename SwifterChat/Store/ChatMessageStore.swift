//
//  ChatData.swift
//  SwifterChat
//
//  Created by Bruno Aguiar on 1/2/16.
//  Copyright © 2016 Bluebeam Apps. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ChatMessageStore {
    
    static let sharedInstance = ChatMessageStore()
    
    let chatMessagePath = "56888c94100000712e83d8c0"
    
    private init() {}
    
    func syncChatMessages(completionHandler: (response: NSURLResponse?, error: NSError?) -> Void) {
        if chatMessagesSynced() == true {
            completionHandler(response: nil, error: nil)
            return
        }
        
        let client = NetworkClient()
        
        NetworkClient.showNetworkIndicator()
        
        client.httpGet(nil, path: chatMessagePath) { (data, response, error) -> Void in
            //This piece of code does not run on the main thread. Instead of managing a separate object context we simply dispatch to the main thread.
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NetworkClient.hideNetworkIndicator()
                
                if error == nil {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSArray
                        
                        try self.addEntriesFromJSON(json)
                        
                        self.setChatMessagesSynced(true)
                    }
                    catch let error as NSError {
                        print("ChatMessageStore: \(error)")
                    }
                }
                
                completionHandler(response: response, error: error)
            })
        }
    }
    
    //MARK: CRUD
    
    func frcForChatMessagesWithChatEntryID(entryID: String) -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(entityName: "ChatMessage")
        
        let predicate = NSPredicate(format: "uIDChatEntryRef == %@", entryID)
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "sectionInfo", cacheName: nil)
        
        do {
            try frc.performFetch()
        }
        catch let error as NSError {
            print(error)
        }
        
        return frc
    }
    
    func insertMessageWithChatEntryID(entryID: String, message: String) {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let newMessage = NSEntityDescription.insertNewObjectForEntityForName("ChatMessage", inManagedObjectContext: context) as! ChatMessage
        
        newMessage.uID = NSUUID().UUIDString
        newMessage.uIDChatEntryRef = entryID
        newMessage.timestamp = NSDate()
        newMessage.uIDOwner = AppDefaults.getUserUID()
        newMessage.message = message
        newMessage.sectionInfo = sectionInfoForMessage(newMessage, calendar: NSCalendar.currentCalendar())
        
        do {
            try context.save()
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    //MARK:
    
    func chatMessagesSynced() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("chatMessagesSynced")
    }
    
    private func setChatMessagesSynced(value: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: "chatMessagesSynced")
    }
    
    private func addEntriesFromJSON(jsonData: NSArray) throws {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let isoDateFormatter = NSDateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        let calendar = NSCalendar.currentCalendar()
        
        for jsonObject in jsonData {
            let chatMessage = NSEntityDescription.insertNewObjectForEntityForName("ChatMessage", inManagedObjectContext: context) as! ChatMessage
            
            chatMessage.uID = jsonObject["uID"] as? String
            chatMessage.uIDChatEntryRef = jsonObject["uIDChatEntryRef"] as? String
            chatMessage.uIDOwner = jsonObject["uIDOwner"] as? String
            chatMessage.message = jsonObject["message"] as? String
            
            if let timestamp = jsonObject["timestamp"] as? String {
                chatMessage.timestamp = isoDateFormatter.dateFromString(timestamp)
                chatMessage.sectionInfo = sectionInfoForMessage(chatMessage, calendar: calendar)
            }
        }
        
        try context.save()
    }
    
    private func sectionInfoForMessage(chatMessage: ChatMessage, calendar: NSCalendar) -> String {
        let components = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: chatMessage.timestamp!)
        let info = (components.year * 10000) + (components.month * 100) + components.day
        
        return String(info)
    }
    
}