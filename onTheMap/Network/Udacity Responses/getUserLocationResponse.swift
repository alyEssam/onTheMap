//
//  getUserLocationResponse.swift
//  onTheMap
//
//  Created by Aly Essam on 9/9/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation

struct student : Codable{
    let createdAt :String?
    let firstName :String?
    let lastName  :String?
    let latitude :Float?
    let longitude :Float?
    let mapString : String?
    let mediaURL : String?
    let objectId : String?
    let uniqueKey : String?
    let updatedAt : String?
}

struct getUserLocationResponse :Codable {
    
    let results : [student]
    
}

/*
 // GETting Student Locations
 {
 "results":[
 {
 "createdAt": "2015-02-25T01:10:38.103Z",
 "firstName": "Jarrod",
 "lastName": "Parkes",
 "latitude": 34.7303688,
 "longitude": -86.5861037,
 "mapString": "Huntsville, Alabama ",
 "mediaURL": "https://www.linkedin.com/in/jarrodparkes",
 "objectId": "JhOtcRkxsh",
 "uniqueKey": "996618664",
 "updatedAt": "2015-03-09T22:04:50.315Z"
 },
 {
 "createdAt":"2015-02-24T22:27:14.456Z",
 "firstName":"Jessica",
 "lastName":"Uelmen",
 "latitude":28.1461248,
 "longitude":-82.756768,
 "mapString":"Tarpon Springs, FL",
 "mediaURL":"www.linkedin.com/in/jessicauelmen/en",
 "objectId":"kj18GEaWD8",
 "uniqueKey":"872458750",
 "updatedAt":"2015-03-09T22:07:09.593Z"
 }
}
 */
