//
//  UdacityConstants.swift
//  Udacity Mapper
//
//  Created by Pushkar Sharma on 14/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation

extension udacityClient{
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let AuthenticatePost = "/session"
        static let GetData = "/users/"
    }


    struct JSONResponseKeys {
        static let objectID = "objectId"
        
        // MARK: Account
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        
        // MARK: DATA
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        
    }
    
}