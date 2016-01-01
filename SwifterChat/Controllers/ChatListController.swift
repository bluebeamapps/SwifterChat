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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        //Fix a glitch where a black shadow is briefly displayed on the top right corner of the nav bar when performing a segue to a different controller.
        navigationController?.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatEntryCell")
        
        return cell!
    }
    
}
