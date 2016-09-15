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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

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
        
        uc.checkUdacityAuth(self, completion: { error in
            if error != nil{
                let alert = UIAlertController(title: "Error!", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }else{
                NSOperationQueue.mainQueue().addOperationWithBlock{
                    self.performSegueWithIdentifier("loggedIn", sender: self)
                }
            }
        })
    }
    
    @IBAction func signUpTapped(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
  
    @IBAction func emailReturned(sender: AnyObject) {
        passwordField.becomeFirstResponder()
    }

    @IBAction func passwordReturned(sender: AnyObject) {
        loginTapped(self)
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        passwordField.resignFirstResponder()
        toggleActivityIndicator()
        if emailField.text == "" || passwordField.text == "" {
            toggleActivityIndicator()
            print("Incomplete form.")
        }else{
            uc.udacityAuth(emailField.text!, password: passwordField.text!, vc: self, completion: { error in
                if error != nil{
                    self.toggleActivityIndicator()
                    let alert = UIAlertController(title: "Error!", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.presentViewController(alert, animated: true, completion: nil)
                    }
                }else{
                    self.toggleActivityIndicator()
                    NSOperationQueue.mainQueue().addOperationWithBlock{
                        self.performSegueWithIdentifier("loggedIn", sender: self)
                    }
                }
            })
        }
    }
    
    func toggleActivityIndicator(){
        self.overlayView.hidden = !self.overlayView.hidden
        self.activityIndicator.isAnimating() ? self.activityIndicator.stopAnimating() : self.activityIndicator.startAnimating()
    }

}

