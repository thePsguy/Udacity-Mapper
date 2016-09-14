//
//  ViewController.swift
//  Udacity Mapper
//
//  Created by Pushkar Sharma on 13/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var overlayView: UIView!

    let uc = udacityClient.sharedInstance()
    let pc = parseClient.sharedInstance()
    
    override func viewWillAppear(animated: Bool) {
        overlayView.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        uc.checkUdacityAuth(self)
    }
    
    @IBAction func signUpTapped(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
  
    @IBAction func emailReturned(sender: AnyObject) {
        passwordField.becomeFirstResponder()
    }

    @IBAction func passwordReturned(sender: AnyObject) {
        self.resignFirstResponder()
        loginTapped(sender)
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        if emailField.text == "" || passwordField.text == "" {
            print("Incomplete form.")
        }else{
            overlayView.hidden = false
            uc.udacityAuth(emailField.text!, password: passwordField.text!, vc: self)
        }
    }

}

