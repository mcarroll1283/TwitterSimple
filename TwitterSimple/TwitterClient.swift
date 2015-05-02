//
//  TwitterClient.swift
//  TwitterSimple
//
//  Created by Matthew Carroll on 5/1/15.
//  Copyright (c) 2015 blarg. All rights reserved.
//

import UIKit


let twitterConsumerKey = "rhwa6TfK0ux5qMp8XZgn23NlP"
let twitterConsumerSecret = "oFYWH8469ljrj5eNuhujIvfgxLEztEvfjw2YvOH2s50zCOfEWN"
let twitterBaseURL  = NSURL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1RequestOperationManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
   
}
