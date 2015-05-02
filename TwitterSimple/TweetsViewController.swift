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
        
        Tweet.getHomeTimelineWithParams(nil, completion: { (tweets, error) in
            if tweets != nil {
                self.tweets = tweets
                println("got \(tweets!.count) tweets in TweetsViewController")
            }
            // TODO: the following line, when table view is setup
            // self.tableView.reloadData()
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
