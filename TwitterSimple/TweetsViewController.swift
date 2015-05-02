//
//  TweetsViewController.swift
//  TwitterSimple
//
//  Created by Matthew Carroll on 5/2/15.
//  Copyright (c) 2015 blarg. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Move this into Tweet model to hide TwitterClient from view controllers
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> Void in
            println("in TweetsViewController with home timeline tweets")
            self.tweets = tweets
            // TODO: the following line, when table view is setup
            // self.tableView.reloadData
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
         User.currentUser?.logout()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
