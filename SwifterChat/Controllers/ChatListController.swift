//
//  ChatListController.swift
//  SwifterChat
//
//  Created by Bruno Aguiar on 12/29/15.
//  Copyright © 2015 Bluebeam Apps. All rights reserved.
//

import Foundation
import UIKit

class ChatListController : UITableViewController {
    
    var chatEntries: [ChatEntry] = []
    var emptyView: EmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyView = NSBundle.mainBundle().loadNibNamed("EmptyView", owner: self, options: nil).first as! EmptyView
        
        tableView.rowHeight = 80
        tableView.backgroundView = emptyView
        
        //Fix a glitch where a black shadow is briefly displayed on the top right corner of the nav bar when performing a segue to a different controller.
        navigationController?.view.backgroundColor = UIColor.whiteColor()
        
        //Attempt to sync data.
        emptyView.showEmptyViewWithMessageType(EmptyView.MessageType.NetworkLoading, tableView: tableView)
        
        syncAppData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatEntries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatEntryCell")
        
        let chatEntry = chatEntries[indexPath.row]
        
        let nameLabel = cell?.viewWithTag(1) as! UILabel
        nameLabel.text = chatEntry.name
        
        let messageLabel = cell?.viewWithTag(4) as! UILabel
        messageLabel.text = chatEntry.lastMessage
        
        if let lastMessageDate = chatEntry.lastMessageDate {
            let dateLabel = cell?.viewWithTag(3) as! UILabel
            dateLabel.text = lastMessageDate.elapsedTimeString()
        }
        
        return cell!
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        let chatEntry = chatEntries[indexPath.row]
        
        let chatDetailsController = segue.destinationViewController as! ChatMessagesController
        chatDetailsController.chatEntry = chatEntry
    }
    
    private func syncAppData() {
        if NetworkClient.isConnectedToNetwork() == false {
            emptyView.showEmptyViewWithMessageType(EmptyView.MessageType.NoInternet, tableView: tableView)
            return
        }
        
        ChatEntryStore.sharedInstance.syncChatEntries { (response, error) -> Void in
            ChatMessageStore.sharedInstance.syncChatMessages({ (response, error) -> Void in
                let sortDescriptors = [NSSortDescriptor(key: "lastMessageDate", ascending: false)]
                
                self.chatEntries = ChatEntryStore.sharedInstance.getChatEntriesWithPredicate(nil, sortDescriptors: sortDescriptors)
                
                self.emptyView.hide(self.tableView)
                self.tableView.reloadData()
            })
        }
    }
}
