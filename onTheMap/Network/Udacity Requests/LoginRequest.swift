//
//  LoginRequest.swift
//  onTheMap
//
//  Created by Aly Essam on 9/5/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation

struct LoginRequest : Codable {
    
    var udacity = [String : String]()
    
    init (username: String ,password: String)
    {
        udacity = ["username" : username , "password" : password]
    }
    
}

/*
 //JSoN Request
request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
*/
