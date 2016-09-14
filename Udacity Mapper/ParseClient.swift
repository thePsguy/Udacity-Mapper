//
//  ParseClient.swift
//  Udacity Mapper
//
//  Created by Pushkar Sharma on 14/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation
import UIKit

final class parseClient {
    
    var session = NSURLSession.sharedSession()
    
    struct Constants {
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let studentsRequestString = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let AppIDField = "X-Parse-Application-Id"
        static let APIKeyField = "X-Parse-REST-API-Key"
    }
    
    func getStudents(completion:(error: NSError?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.studentsRequestString)!)
        request.addValue(Constants.ApplicationID, forHTTPHeaderField: Constants.AppIDField)
        request.addValue(Constants.RestAPIKey, forHTTPHeaderField: Constants.APIKeyField)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                completion(error: error!)
                return
            }
            let dataDict = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            let students = student.studentsFromResults(dataDict["results"] as! [[String : AnyObject]])
            (UIApplication.sharedApplication().delegate as! AppDelegate).students = students
            completion(error: nil)
        }
        task.resume()
    }
    
    func postPin(dat: user, lat: String, long: String, mapString: String, mediaUrl: String, completion:(error: NSError?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var reqString = "{\"uniqueKey\": \"" + String(dat.id) + "\", \"firstName\": \"" + dat.firstName + "\", \"lastName\": \""
        reqString += dat.lastName + "\",\"mapString\": \"" + mapString + "\", \"mediaURL\": \"" + mediaUrl + "\",\"latitude\": " + lat + ", \"longitude\": " + long + "}"
            
        request.HTTPBody = reqString.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completion(error: error)
            }
            print("Object Created.")
            completion(error: nil)
        }
        task.resume()
    }

    
    class func sharedInstance() -> parseClient {
        struct Singleton {
            static var sharedInstance = parseClient()
        }
        return Singleton.sharedInstance
    }
    
}