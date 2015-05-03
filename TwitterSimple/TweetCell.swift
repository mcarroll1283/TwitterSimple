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

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}