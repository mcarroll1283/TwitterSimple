//
//  Tweet.swift
//  TwitterSimple
//
//  Created by Matthew Carroll on 5/2/15.
//  Copyright (c) 2015 blarg. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var author: User?
    var text: String?
    var createdAt: NSDate?
    
    init(dictionary: NSDictionary) {
        if let authorInfo = dictionary["user"] as? NSDictionary {
            author = User(dictionary: authorInfo)
        } else {
            println("Tweet model: no user")
        }
        
        if let dateString = dictionary["created_at"] as? String {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.dateFromString(dateString)
        } else {
            println("Tweet model: no created_at")
        }

    }
    
    class func getHomeTimelineWithParams(params: HomeTimelineParams?, completion: HomeTimelineCompletion) {
        TwitterClient.sharedInstance.getHomeTimelineWithParams(params, completion: completion)
    }
}
