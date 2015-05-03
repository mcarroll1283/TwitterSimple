//
//  DetailViewController.swift
//  TwitterSimple
//
//  Created by Matthew Carroll on 5/3/15.
//  Copyright (c) 2015 blarg. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("detail loaded with tweet: \(tweet.author?.name)")
        
        if let author = tweet.author {
            
            if let imageUrl = author.profileImageUrl {
                authorImageView.setImageWithURL(NSURL(string: imageUrl))
            } else {
                println("DetailViewController got tweet with author with no image url")
            }
            
            if let name = author.name {
                nameLabel.text = name
            } else {
                println("DetailViewController got author with no name")
            }
            
            if let screenName = author.screenname {
                screenNameLabel.text = screenName
            } else {
                println("DetailViewController got author with no screenname")
            }
            
        } else {
            println("DetailViewController got tweet with no author")
        }
        
        if let tweetText = tweet.text {
            tweetLabel.text = tweetText
        } else {
            println("DetailViewController got tweet with no text")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        tweet.favorite()
    }

    @IBAction func onRetweet(sender: AnyObject) {
        tweet.retweet()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "replySegue" {
            println("going to compose view to reply to tweet id: \(tweet.idStr)")
            let composeVC = segue.destinationViewController as ComposeViewController
            composeVC.inReplyTo = (tweet.idStr!, tweet.author!.screenname!)
        }
    }

}
