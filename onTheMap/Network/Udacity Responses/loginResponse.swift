//
//  loginResponse.swift
//  onTheMap
//
//  Created by Aly Essam on 9/5/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation


struct account : Codable {
    
    let registered : Bool
    let key : String
}

struct session : Codable {
    let id : String
    let expiration : String
}

struct loginResponse : Codable {
    let account : account
    let session : session
}

/*
 //JSON Response
{
    "account":{
        "registered":true,
        "key":"3903878747"
    },
    "session":{
        "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
        "expiration":"2015-05-10T16:48:30.760460Z"
    }
}

 */
