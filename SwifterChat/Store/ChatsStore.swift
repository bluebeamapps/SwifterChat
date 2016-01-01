//
//  ChatsStore.swift
//  SwifterChat
//
//  Created by Bruno Aguiar on 12/29/15.
//  Copyright © 2015 Bluebeam Apps. All rights reserved.
//

import Foundation

class ChatsStore {
    //TODO: Singleton.
    
    let chatEntriesPath = ""
    let chatMessagesPath = ""
    
    func getChatEntries(completionHandler: (data: NSData?, error: NSError?) -> Void) {
        let client = NetworkClient()
        
        client.httpGet(nil, path: chatEntriesPath) { (data, response, error) -> Void in
            completionHandler(data: data, error: error)
        }
    }
    
    func getChatMessages(completionHandler: (data: NSData?, error: NSError?) -> Void) {
        let client = NetworkClient()
        
        client.httpGet(nil, path: chatMessagesPath) { (data, response, error) -> Void in
            completionHandler(data: data, error: error)
        }
    }
}
