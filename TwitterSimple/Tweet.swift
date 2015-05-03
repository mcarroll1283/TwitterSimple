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
    var idStr: String?
    
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
        
        if let tweetText = dictionary["text"] as? String {
            text = tweetText
        } else {
            println("Tweet model: no text")
        }
        
        if let dictIdStr = dictionary["id_str"] as? String {
            idStr = dictIdStr
        } else {
            println("Tweet model: no id_str")
        }
    }
    
    func favorite() {
        if let idStr = idStr {
            TwitterClient.sharedInstance.favoriteTweet(idStr)
        } else {
            println("Tweet model: can't favorite because it has no idStr")
        }
    }
    
    func retweet() {
        if let idStr = idStr {
            TwitterClient.sharedInstance.retweetTweet(idStr)
        } else {
            println("Tweet model: can't favorite because it has no idStr")
        }
        
    }
    
    class func getHomeTimelineWithParams(params: HomeTimelineParams?, completion: HomeTimelineCompletion) {
        TwitterClient.sharedInstance.getHomeTimelineWithParams(params, completion: completion)
    }
    
    class func postTweet(tweetText: String, inReplyToIdStr: String="") {
        TwitterClient.sharedInstance.postTweet(tweetText, inReplyToIdStr: inReplyToIdStr)
    }
}
