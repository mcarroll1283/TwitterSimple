//
//  User.swift
//  TwitterSimple
//
//  Created by Matthew Carroll on 5/2/15.
//  Copyright (c) 2015 blarg. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "_cu"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                var dictionary: NSDictionary?
                if data != nil {
                    dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as? NSDictionary
                    if dictionary != nil {
                        _currentUser = User(dictionary: dictionary!)
                    } else {
                        println("Error deserializing user data from user defaults")
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if (_currentUser != nil) {
                let data = NSJSONSerialization.dataWithJSONObject(_currentUser!.dictionary!, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
}
