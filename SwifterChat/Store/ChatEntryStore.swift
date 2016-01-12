//
//  ChatsStore.swift
//  SwifterChat
//
//  Created by Bruno Aguiar on 12/29/15.
//  Copyright © 2015 Bluebeam Apps. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ChatEntryStore {
    
    static let sharedInstance = ChatEntryStore()
    
    let chatEntriesPath = "5687f77d100000e20c83d8ac"
    
    private init() {}
    
    func syncChatEntries(completionHandler: (response: NSURLResponse?, error: NSError?) -> Void) {
        if chatEntriesSynced() == true {
            completionHandler(response: nil, error: nil)
            return
        }
        
        let client = NetworkClient()
        
        NetworkClient.showNetworkIndicator()
        
        client.httpGet(nil, path: chatEntriesPath) { (data, response, error) -> Void in
            //This piece of code does not run on the main thread. Instead of managing a separate object context we simply dispatch to the main thread.
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NetworkClient.hideNetworkIndicator()
                
                if error == nil {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSArray
                        
                        try self.addEntriesFromJSON(json)
                        
                        self.setChatEntriesSynced(true)
                    }
                    catch let error as NSError {
                        print("ChatEntryStore: \(error)")
                    }
                }
                
                completionHandler(response: response, error: error)
            })
        }
    }
    
    //MARK: CRUD
    
    func getChatEntriesWithPredicate(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [ChatEntry] {
        let fetchRequest = NSFetchRequest(entityName: "ChatEntry")
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        var entries: [ChatEntry] = []
        
        do {
            entries = try context.executeFetchRequest(fetchRequest) as! [ChatEntry]
        }
        catch let error as NSError {
            print("ChatEntryStore: \(error)")
        }
        
        return entries
    }
    
    //MARK:
    
    func chatEntriesSynced() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("chatEntriesSynced")
    }
    
    private func setChatEntriesSynced(value: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: "chatEntriesSynced")
    }
    
    private func addEntriesFromJSON(jsonData: NSArray) throws {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let isoDateFormatter = NSDateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        for jsonObject in jsonData {
            let chatEntry = NSEntityDescription.insertNewObjectForEntityForName("ChatEntry", inManagedObjectContext: context) as! ChatEntry
            
            chatEntry.uID = jsonObject["uID"] as? String
            chatEntry.name = jsonObject["name"] as? String
            chatEntry.lastMessage = jsonObject["lastMessage"] as? String
            
            if let lastMessageDate = jsonObject["lastMessageDate"] as? String {
                chatEntry.lastMessageDate = isoDateFormatter.dateFromString(lastMessageDate)
            }
        }
        
        try context.save()
    }

}
