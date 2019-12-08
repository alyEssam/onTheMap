//
//  UdacityResponse.swift
//  onTheMap
//
//  Created by Aly Essam on 9/5/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation

struct UdacityResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension UdacityResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}

