//
//  newStudentInfo.swift
//  onTheMap
//
//  Created by Aly Essam on 9/11/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation


struct newStudentInfo: Codable{
    // here i add new student data to pass it to the db
    static var uniqueKey : String = UdacityClient.Auth.userID
    static var firstName :String = "None First Name"
    static var lastName  :String = "None First Name"
    static var latitude :Double = 0.0
    static var longitude :Double = 0.0
    static var mapString : String = ""
    static var mediaURL : String = ""
}


