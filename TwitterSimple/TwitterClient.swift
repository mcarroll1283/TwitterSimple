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

typealias LoginCompletion = ((userData: NSDictionary?, error: NSError?) -> Void)
// TODO: Make this specific to the appropriate params
typealias HomeTimelineParams = NSDictionary
typealias HomeTimelineCompletion = ((tweets: [Tweet]?, error: NSError?) -> Void)

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: LoginCompletion?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func getHomeTimelineWithParams(params: HomeTimelineParams?, completion: HomeTimelineCompletion) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let tweetInfoArray = response as [NSDictionary]
            let tweets = map(tweetInfoArray, { (tweetInfo) in
                Tweet(dictionary: tweetInfo)
            })
            println("Got timeline with \(tweets.count) tweets")
            completion(tweets: tweets, error: nil)
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("Error getting timeline")
            completion(tweets: nil, error: error)
        })
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
                self.loginCompletion?(userData: nil, error: error)
        })
    }
    
    func openUrl(url: NSURL) {
        fetchAccessTokenWithPath(
            "oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
                self.requestSerializer.saveAccessToken(accessToken)
                
                self.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    
                    let responseDict = response as NSDictionary
                    self.loginCompletion?(userData: responseDict, error: nil)
                    
                    }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        println("Error getting user: \(error)")
                        self.loginCompletion?(userData: nil, error: error)
                })
                
            }) { (error: NSError!) -> Void in
                println("Error getting access token: \(error)")
                self.loginCompletion?(userData: nil, error: error)
        }
    }
    
    func postTweet(tweetText: String, inReplyToIdStr: String="") {
        println("TwitterClient compose tweet: \(tweetText), in reply to \(inReplyToIdStr)")
        let params = ["status": tweetText, "in_reply_to_status_id": inReplyToIdStr]
        let urlString = "1.1/statuses/update.json"
        POST(urlString, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("postTweet: success")
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("postTweet: error")
        }
    }
    
    func favoriteTweet(tweetIdStr: String) {
        println("TwitterClient favorite tweet with id: \(tweetIdStr)")
        let params = ["id": tweetIdStr]
        let urlString = "https://api.twitter.com/1.1/favorites/create.json"
        POST(urlString, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("favoriteTweet: success")
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("favoriteTweet: error")
        }
    }
   
}
