//
//  ComposeViewController.swift
//  TwitterSimple
//
//  Created by Matthew Carroll on 5/3/15.
//  Copyright (c) 2015 blarg. All rights reserved.
//

import UIKit

let maxTweetLength = 140

protocol ComposeViewControllerDelegate: class {
    func composeViewController(composeViewController: UIViewController, didComposeTweet didCompose: Bool)
}

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var currentUserImageView: UIImageView!
    @IBOutlet weak var currentUserNameLabel: UILabel!
    @IBOutlet weak var currentUserScreenNameLabel: UILabel!
    @IBOutlet weak var charsLeftLabel: UILabel!
    
    weak var delegate: ComposeViewControllerDelegate?
    
    
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
        let urlString = User.currentUser!.profileImageUrl!
        currentUserImageView.setImageWithURL(NSURL(string: urlString))
        currentUserNameLabel.text = User.currentUser!.name
        currentUserScreenNameLabel.text = User.currentUser!.screenname
        
        tweetTextView.delegate = self
        
        tweetTextView.becomeFirstResponder()

        updateCharsLeft()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        if let inReplyTo = inReplyTo {
            let inReplyToIdStr = inReplyTo.0
            Tweet.postTweet(tweetTextView.text, inReplyToIdStr: inReplyToIdStr, complete: { () -> () in
                self.dismissViewControllerAnimated(true, completion: nil)
                self.delegate?.composeViewController(self, didComposeTweet: true)
            })
            Tweet.postTweet(tweetTextView.text, inReplyToIdStr: inReplyToIdStr)
        } else {
            Tweet.postTweet(tweetTextView.text, inReplyToIdStr: "", complete: { () -> () in
                self.dismissViewControllerAnimated(true, completion: nil)
                self.delegate?.composeViewController(self, didComposeTweet: true)
            })
        }

        // TODO: Should I want for success before dismissing?
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView) {
        updateCharsLeft()
    }
    
    private func updateCharsLeft() {
        let enteredTweetLength = countElements(tweetTextView.text)
        charsLeftLabel.text = "\(maxTweetLength - enteredTweetLength)"
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
