//
//  UdacityClient.swift
//  Udacity Mapper
//
//  Created by Pushkar Sharma on 14/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation

class udacityClient: NSObject {

    var session = NSURLSession.sharedSession()
    
    // create a URL from parameters
    private func udacityURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? ) -> NSURL {
        let components = NSURLComponents()
        components.scheme = udacityClient.Constants.ApiScheme
        components.host = udacityClient.Constants.ApiHost
        components.path = udacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.URL!
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> udacityClient {
        struct Singleton {
            static var sharedInstance = udacityClient()
        }
        return Singleton.sharedInstance
    }
}