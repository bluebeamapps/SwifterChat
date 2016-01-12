//
//  ChatEntry+CoreDataProperties.swift
//  SwifterChat
//
//  Created by Bruno Aguiar on 1/2/16.
//  Copyright © 2016 Bluebeam Apps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ChatEntry {

    @NSManaged var uID: String?
    @NSManaged var name: String?
    @NSManaged var lastMessage: String?
    @NSManaged var lastMessageDate: NSDate?

}
