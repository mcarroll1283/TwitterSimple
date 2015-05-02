//
//  ViewController.swift
//  TwitterSimple
//
//  Created by Matthew Carroll on 5/1/15.
//  Copyright (c) 2015 blarg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        TwitterClient.sharedInstance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mctwittersimple://oauth"), scope: nil, success: { (credential) -> Void in
            let maybeAuthUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(credential.token)")
            if let authUrl = maybeAuthUrl {
                UIApplication.sharedApplication().openURL(authUrl)
            }
//            UIApplication.sharedApplication().openURL(authURL)
        }, failure: { (error) -> Void in
            println("error")
        })
    }
}

