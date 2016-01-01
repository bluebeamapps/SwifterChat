//
//  ContactsController.swift
//  SwifterChat
//
//  Created by Bruno Aguiar on 12/31/15.
//  Copyright © 2015 Bluebeam Apps. All rights reserved.
//

import Foundation
import UIKit

class ContactsController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactEntryCell")
        
        //TODO:
        let nameLabel = cell?.viewWithTag(30) as! UILabel
        
        return cell!
    }
}
