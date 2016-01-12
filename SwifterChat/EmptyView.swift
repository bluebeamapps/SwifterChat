//
//  EmptyView.swift
//  SwifterChat
//
//  Created by Bruno Aguiar on 1/2/16.
//  Copyright © 2016 Bluebeam Apps. All rights reserved.
//

import Foundation
import UIKit

class EmptyView : UIView {
    
    @IBOutlet var label: UILabel!
    
    enum MessageType {
        case NoInternet
        case NetworkLoading
        case NetworkError
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hidden = true
    }
    
    func showEmptyViewWithMessageType(messageType: MessageType, tableView: UITableView) {
        var message: String
        
        switch messageType {
            
        case .NoInternet:
            message = NSLocalizedString("You are not connected to the internet", comment: "TableView no network connection message.")
            
        case .NetworkLoading:
            message = NSLocalizedString("Loading the data, this should only take a moment...", comment: "TableView's network call message.")
            
        case .NetworkError:
            message = NSLocalizedString("We were unable to load your data. Please try again in a moment", comment: "TableView network error message.")
        }
        
        label!.text = message;
        hidden = false;
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.reloadData() //TableView has to be reloaded in order for the line above to work.
    }
    
    func hide(tableView: UITableView) {
        if hidden == false {
            hidden = true
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
    }
}