//
//  currentUserResponse.swift
//  onTheMap
//
//  Created by Aly Essam on 9/11/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation

struct currentUserResponse: Codable{
    var lastName: String?
    var firstName: String?
    var nickName:String?
    
    enum CodingKeys: String, CodingKey{
        case lastName = "last_name"
        case firstName = "first_name"
        case nickName = "nickname"
    }
}
