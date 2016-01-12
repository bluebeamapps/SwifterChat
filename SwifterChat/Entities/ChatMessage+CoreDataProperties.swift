//
//  ChatMessage+CoreDataProperties.swift
//  SwifterChat
//
//  Created by Bruno Aguiar on 1/4/16.
//  Copyright © 2016 Bluebeam Apps. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ChatMessage {

    @NSManaged var isdeleted: NSNumber?
    @NSManaged var message: String?
    @NSManaged var timestamp: NSDate?
    @NSManaged var uID: String?
    @NSManaged var uIDChatEntryRef: String?
    @NSManaged var uIDOwner: String?
    @NSManaged var sectionInfo: String?

}
