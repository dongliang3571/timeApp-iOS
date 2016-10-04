//
//  Session.swift
//  timeApp-iOS
//
//  Created by dong liang on 7/26/16.
//  Copyright © 2016 kanic. All rights reserved.
//

import UIKit

class Session: NSObject {
    var isActive: Bool?
    
    // Using format 07/26 12:32 for sign in time
    var _signInTime: String!
    var signInTime: String? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: _signInTime)
            dateFormatter.dateFormat = "HH:mm a"
            let dateString = dateFormatter.string(from: date!)
            return dateString
        }
    }
    
    // Using format 07/26 12:32 for sign out time
    var _signOutTime: String!
    var signOutTime: String? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: _signOutTime)
            dateFormatter.dateFormat = "HH:mm a"
            let dateString = dateFormatter.string(from: date!)
            return dateString
        }
    }
    var team: String?
    var total_minutes: Float?
    var user: String?
    
    init(dictionary: NSDictionary) {
        if dictionary["is_active"] as! Int == 0 {
            self.isActive = false
        } else {
            self.isActive = true
        }
        
        if let signInTime = dictionary["signed_in"] as? String {
            self._signInTime = signInTime
        }
        
        if let signOutTime = dictionary.object(forKey: "signed_out") {
            self._signOutTime = signOutTime as! String
        }
        
        if let team = dictionary.object(forKey: "team") {
            self.team = team as? String
        } else {
            self.team = nil
        }
        
        if let total_minutes = dictionary.object(forKey: "total_minutes") {
            self.total_minutes = total_minutes as? Float
        } else {
            self.total_minutes = nil
        }
        
        if let user = dictionary.object(forKey: "user") {
            self.user = user as? String
        }
        
    }
}
