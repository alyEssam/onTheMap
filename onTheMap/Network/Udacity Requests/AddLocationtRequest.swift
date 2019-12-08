//
//  AddLocationtRequest.swift
//  onTheMap
//
//  Created by Aly Essam on 9/9/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation

struct AddLocationtRequest : Codable{
    
    let uniqueKey : String = UdacityClient.Auth.userID
    let firstName :String
    let lastName  :String
    let latitude :Double
    let longitude :Double
    let mapString : String
    let mediaURL : String
}
