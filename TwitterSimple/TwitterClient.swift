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

typealias LoginCompletion = ((user: User?, error: NSError?) -> Void)

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: LoginCompletion?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func login(onComplete: LoginCompletion) {
        loginCompletion = onComplete
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mctwittersimple://oauth"), scope: nil, success: { (credential) -> Void in
            let maybeAuthUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(credential.token)")
            if let authUrl = maybeAuthUrl {
                UIApplication.sharedApplication().openURL(authUrl)
            }
            }, failure: { (error) -> Void in
                println("Error getting request token: \(error)")
                self.loginCompletion?(user: nil, error: error)
        })
    }
    
    func openUrl(url: NSURL) {
        fetchAccessTokenWithPath(
            "oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
                self.requestSerializer.saveAccessToken(accessToken)
                
                self.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    
                    let user = User(dictionary: response as NSDictionary)
                    println("User = \(user.name)")
                    User.currentUser = user
                    self.loginCompletion?(user: user, error: nil)
                    
                    }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        println("Error getting user: \(error)")
                })
                
                self.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    
                    let tweetInfoArray = response as [NSDictionary]
                    let tweets = map(tweetInfoArray, { (tweetInfo) in
                        Tweet(dictionary: tweetInfo)
                    })
                    for tweet in tweets {
                        println("\(tweet.author!.name!) on \(tweet.createdAt!)")
                    }
                    
                    }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        println("error getting timeline")
                })
            }) { (error: NSError!) -> Void in
                println("Error getting access token: \(error)")
                self.loginCompletion?(user: nil, error: error)
        }
    }
   
}
