//
//  TweetCell.swift
//  TwitterSimple
//
//  Created by Matthew Carroll on 5/3/15.
//  Copyright (c) 2015 blarg. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            if let author = tweet.author {
                if author.profileImageUrl != nil {
                    authorImageView.setImageWithURL(NSURL(string: author.profileImageUrl!))
                } else {
                    println("Error: tweet model with author with no profile image url")
                }
                if author.name != nil {
                    nameLabel.text = author.name!
                } else {
                    println("Error: tweet model with author with no name")
                }
            } else {
                println("Error: tweet model with no author")
            }
            
            if let text = tweet.text {
                tweetTextLabel.text = text
            } else {
                println("Error: tweet model with no text")
            }
            
            if tweet.createdAt != nil {
                let secondsPerDay = (60 * 60 * 24) as Double
                let oneDayAgo = NSDate(timeIntervalSinceNow: -1.0 * secondsPerDay)
                var timestampText = tweet.createdAt!.shortTimeAgoSinceNow()
                if tweet.createdAt!.isEarlierThan(oneDayAgo) {
                    let a = tweet.createdAt!.formattedDateWithStyle(NSDateFormatterStyle.LongStyle)
                    let b = oneDayAgo.formattedDateWithStyle(NSDateFormatterStyle.LongStyle)
                    timestampText = tweet.createdAt!.formattedDateWithStyle(NSDateFormatterStyle.ShortStyle)
                }
                timestampLabel.text = timestampText
            }

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.bounds.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.bounds.width
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.bounds.width
    }

}
