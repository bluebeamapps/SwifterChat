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
    
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60
        
        var contact = Contact(withName: "Bruno Aguiar", status: "Available")
        contacts.append(contact)
        
        contact = Contact(withName: "Kate Webb", status: "Busy")
        contacts.append(contact)
        
        contact = Contact(withName: "Phil Collins", status: "Playing Drums")
        contacts.append(contact)
        
        contact = Contact(withName: "Steve Jobz", status: "")
        contacts.append(contact)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactEntryCell")
        
        let contact = contacts[indexPath.row]

        let nameLabel = cell?.viewWithTag(20) as! UILabel
        nameLabel.text = contact.name
        
        let statusLabel = cell?.viewWithTag(30) as! UILabel
        statusLabel.text = contact.status
        
        return cell!
    }
}

struct Contact {
    
    var name: String?
    var status: String?
    
    init(withName name: String?, status: String?) {
        self.name = name
        self.status = status
    }
}
