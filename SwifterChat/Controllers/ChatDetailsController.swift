//
//  ChatDetailsController.swift
//  SwifterChat
//
//  Created by Bruno Aguiar on 12/29/15.
//  Copyright © 2015 Bluebeam Apps. All rights reserved.
//

import Foundation
import UIKit

class ChatDetailsController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        
        navigationController?.toolbarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.toolbarHidden = true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row % 2 == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("ChatMessageCellLeft")
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("ChatMessageCellRight")
        }
        
        let container = cell.viewWithTag(100)!
        container.layer.cornerRadius = 15
        container.layer.shadowOffset = CGSize(width: indexPath.row % 2 == 0 ? 1 : -1, height: 1)
        container.layer.shadowOpacity = 0.20
        container.layer.shadowRadius = 0.5
        container.layer.masksToBounds = false
        
//        let messageLabel = container.viewWithTag(101) as! UILabel
        
        return cell
    }
    
}