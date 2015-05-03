//
//  ComposeViewController.swift
//  TwitterSimple
//
//  Created by Matthew Carroll on 5/3/15.
//  Copyright (c) 2015 blarg. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    // This tuple contains the tweet id and the tweet author screenname.
    // We need the screenname because unless the tweet text contains @<screenname>,
    // the reply to ID will be ignored by the API. So we want to pre-fill the text
    // with @<screenname>.
    var inReplyTo: (String, String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let inReplyTo = inReplyTo {
            tweetTextView.text = "@\(inReplyTo.1) "
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        if let inReplyTo = inReplyTo {
            let inReplyToIdStr = inReplyTo.0
            Tweet.postTweet(tweetTextView.text, inReplyToIdStr: inReplyToIdStr)
        } else {
            Tweet.postTweet(tweetTextView.text)
        }

        // TODO: Should I want for success before dismissing?
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
