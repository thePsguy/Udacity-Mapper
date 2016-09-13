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

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "sso_auth" && cookie.sessionOnly == false && NSDate.init().compare(cookie.expiresDate!) == .OrderedAscending && cookie.domain == ".udacity.com"{
                print("Pre Auth!")
                checkUdacityAuth()
            }
        }
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
            udacityAuth(emailField.text!, password: passwordField.text!)
        }
    }

    func udacityAuth(username: String, password: String){
        let username = "thePsguy@icloud.com"
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpBody = "{\"udacity\": {\"username\": \""+username+"\", \"password\": \""+password+"\"}}"
        request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                print("ERROR: ", error)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            let parsed = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
            if parsed["error"] == nil && parsed["account"]!["registered"]! as! Bool == true{
                let uid = Int(parsed["account"]!["key"]! as! String)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.performSegueWithIdentifier("loggedIn", sender: uid)
                }
            }
        }
        task.resume()
    }

    func checkUdacityAuth(){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "GET"
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                print("ERROR: ", error)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            let parsed = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
            if parsed["error"] == nil && parsed["account"]!["registered"]! as! Bool == true{
                let uid = Int(parsed["account"]!["key"]! as! String)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    let alert = UIAlertController(title: "Session found", message: "Logging in automatically.", preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(alert, animated: true, completion: {
                        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
                        dispatch_after(time, dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("loggedIn", sender: uid)
                        }
                    })
                }
            }else{
                let alert = UIAlertController(title: "Session not found", message: "Please login above.", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        task.resume()
    }


}

