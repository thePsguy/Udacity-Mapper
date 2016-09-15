//
//  StudentStorage.swift
//  Udacity Mapper
//
//  Created by Pushkar Sharma on 15/09/2016.
//  Copyright © 2016 thePsguy. All rights reserved.
//

import Foundation

final class studentStorage{
    var students = [student]()
    
    func setStudentData(data: [student]){
        students = data
    }

    func getStudentData() -> [student]{
        return students
    }
    
    class func sharedInstance() -> studentStorage {
        struct Singleton {
            static var sharedInstance = studentStorage()
        }
        return Singleton.sharedInstance
    }

}