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
        // TODO: Move this into User class, to fully hide TwitterClient
        // from view controllers
        TwitterClient.sharedInstance.login() { (user, error) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // handle login error
            }
        }
    }
}

