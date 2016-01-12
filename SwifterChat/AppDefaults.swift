//
//  AppDefaults.swift
//  SwifterChat
//
//  Created by Bruno Aguiar on 1/2/16.
//  Copyright © 2016 Bluebeam Apps. All rights reserved.
//

import Foundation

class AppDefaults {
    
    private static let UserUIDKey = "UserUID"
    
    class func setUserUID(userUID: String) {
        NSUserDefaults.standardUserDefaults().setObject(userUID, forKey: UserUIDKey)
    }
    
    class func getUserUID() -> String {
        return NSUserDefaults.standardUserDefaults().valueForKey(UserUIDKey) as! String
    }
    
}