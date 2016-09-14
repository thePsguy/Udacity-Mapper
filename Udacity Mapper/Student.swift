//
//  Student.swift
//  Udacity Mapper
//
//  Created by Pushkar Sharma on 14/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation

struct student {
    
    // MARK: Properties
    
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let latitude: Float!
    let longitude: Float!
    let mapString: String?
    let mediaUrl: String?
    let objectID: String
    let createdAt: String?
    let updatedAt: String?
    
    // MARK: Initializers
    
    // construct a Student from a dictionary
    init(dictionary: [String:AnyObject]) {
        firstName = dictionary[udacityClient.JSONResponseKeys.firstName] as? String
        lastName = dictionary[udacityClient.JSONResponseKeys.lastName] as? String

        uniqueKey = dictionary[udacityClient.JSONResponseKeys.uniqueKey] as? String
        objectID = dictionary[udacityClient.JSONResponseKeys.objectID] as! String

        latitude = dictionary[udacityClient.JSONResponseKeys.latitude] as? Float
        longitude = dictionary[udacityClient.JSONResponseKeys.longitude] as? Float
        
        mapString = dictionary[udacityClient.JSONResponseKeys.mapString] as? String
        mediaUrl = dictionary[udacityClient.JSONResponseKeys.mediaURL] as? String
        
        
        createdAt = dictionary[udacityClient.JSONResponseKeys.createdAt] as? String
        updatedAt = dictionary[udacityClient.JSONResponseKeys.updatedAt] as? String
    }
    
    static func studentsFromResults(results: [[String:AnyObject]]) -> [student] {
        
        var students = [student]()
        
        // iterate through array of dictionaries, each Student is a dictionary
        for result in results {
            if(result["latitude"] != nil && result["longitude"] != nil){
                students.append(student(dictionary: result))
            }
        }
        return students
    }
}

// MARK: - TMDBMovie: Equatable

extension student: Equatable {}

func ==(lhs: student, rhs: student) -> Bool {
    return lhs.uniqueKey == rhs.uniqueKey
}

