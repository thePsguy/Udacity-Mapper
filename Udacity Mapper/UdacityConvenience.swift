//
//  UdacityConvenience.swift
//  Udacity Mapper
//
//  Created by Pushkar Sharma on 14/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import UIKit

extension udacityClient {

    func udacityAuth(username: String, password: String, vc: LoginViewController, completion: (error: String?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpBody = "{\"udacity\": {\"username\": \""+username+"\", \"password\": \""+password+"\"}}"
        request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completion(error: "Network Error.")
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            let parsed = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as! NSDictionary
            if parsed["error"] == nil && parsed["account"]!["registered"]! as! Bool == true{
                let uid = Int(parsed["account"]!["key"]! as! String)!
                self.getUserDataForID(uid, vc: vc, completion: completion)
            }
            else if parsed["error"] != nil{
                completion(error: parsed["error"] as? String)
            }
        }
        task.resume()
    }
    
    func checkUdacityAuth(vc: LoginViewController, completion: (error: String?) -> Void){
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "sso_auth" && cookie.sessionOnly == false && NSDate.init().compare(cookie.expiresDate!) == .OrderedAscending && cookie.domain == ".udacity.com"{
                print("Pre Authorized.")
                
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
                        let uid = Int(parsed["account"]!["key"]! as! String)!
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            let alert = UIAlertController(title: "Existing Session Found", message: "Log in automatically?", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction) in
                                vc.toggleActivityIndicator()
                                self.getUserDataForID(uid, vc: vc, completion: completion)
                            }))
                            
                            alert.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(action: UIAlertAction) in
                                self.deleteSession(vc)
                            })
                            )
                            vc.presentViewController(alert, animated: true, completion: nil)
                        }
                    }else{
                        let alert = UIAlertController(title: "Session not found", message: "Please login above.", preferredStyle: UIAlertControllerStyle.Alert)
                        vc.presentViewController(alert, animated: true, completion: nil)
                    }
                }
                task.resume()
            }
        }
    }
    
    func getUserDataForID(userID: Int, vc: LoginViewController, completion: (error: String?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/" + String(userID))!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                print("ERROR: ", error)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            let parsed = try! NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            let appDel = (UIApplication.sharedApplication().delegate as! AppDelegate)
            appDel.userObject.id = userID
            appDel.userObject.firstName = parsed["user"]!!["first_name"]! as! String
            appDel.userObject.lastName = parsed["user"]!!["last_name"]! as! String
            completion(error: nil)
        }
        task.resume()
    }


    func deleteSession(vc: UIViewController){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            //            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            NSOperationQueue.mainQueue().addOperationWithBlock {
                vc.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        task.resume()
    }
    
}
