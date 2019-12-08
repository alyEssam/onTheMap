//
//  UdacityClient.swift
//  onTheMap
//
//  Created by Aly Essam on 8/26/19.
//  Copyright © 2019 Aly Essam. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient  {
    static let apiMethod = "https://onthemap-api.udacity.com/v1/StudentLocation"
    
    struct Auth {
        static var registered = true
        static var userID = ""
        static var sessionId = ""
    }
    enum Endpoints {
        
        static let apiKeyParam = "\(UdacityClient.apiMethod)"
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case signup
        case createSessionId
        case logout
        case studentlocation
        case getStudentData
        case postStudentLocation
        
        var stringValue: String {
            switch self {
            case .createSessionId:
                 return Endpoints.base + "/session"
                
            case .signup:
                 return "https://auth.udacity.com/sign-up"
            case .logout:
                return  Endpoints.base + "/session"
            case .studentlocation:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .getStudentData:
                return Endpoints.base + "/users/\(Auth.userID)"
            case .postStudentLocation:
                return Endpoints.base + "/StudentLocation"
            }
        }
            var url: URL {
                return URL(string: stringValue)!
            }
}
    
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, udacityApiFlag:Bool, completion: @escaping (ResponseType?, Error?) -> Void){
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGETRequest", code: 1, userInfo: userInfo))
            }
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                sendError("Request did not return a valid response.")
                return
            }
            
            switch (statusCode) {
            case 403:
                sendError("Please check your email and password")
            case 200 ..< 299:
                break
            default:
                sendError("Please try again later!!")
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
           
            let decoder = JSONDecoder()

            do {
                 let responseObject : Any
                if udacityApiFlag == true {
                    let range = (5..<data.count)
                    let newData = data.subdata(in: range)
                    responseObject = try decoder.decode(ResponseType.self, from: newData)
                }else {
                    responseObject = try decoder.decode(ResponseType.self, from: data)
                }
                DispatchQueue.main.async {
                    print("Good get data")
                    completion((responseObject as! ResponseType), nil)
                }
            } catch {
                do { let errorResponse = try decoder.decode(UdacityResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                }
                catch {
                    DispatchQueue.main.async {                        
                        completion(nil, error)
                    }
                    
                }
            }
        }
    task.resume()
}
    
    
 
    
        class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, udacityApiFlag:Bool, completion: @escaping (ResponseType?, Error?) -> Void) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try! JSONEncoder().encode(body)
      
            //Tell the server that our data is in the json format
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
                func sendError(_ error: String) {
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completion(nil, NSError(domain: "taskForPOSTRequest", code: 1, userInfo: userInfo))
                }
                guard error == nil else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    sendError("Request did not return a valid response.")
                    return
                }
                
                switch (statusCode) {
                case 403:
                    sendError("Incorrect user name or password")
                case 200 ..< 299:
                    break
                default:
                    sendError("Please try again later!!")
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let responseObject : Any
                    if udacityApiFlag == true {
                        let range = (5..<data.count)
                        let newData = data.subdata(in: range)
                        responseObject = try decoder.decode(responseType.self, from: newData)
                    }
                    else {
                     responseObject = try decoder.decode(responseType.self, from: data)
                    }
                    DispatchQueue.main.async {
                        print("Good Login")
                        completion((responseObject as! ResponseType), nil)
                    }
                } catch {
                    do { let errorResponse = try decoder.decode(UdacityResponse.self, from: data)
                        DispatchQueue.main.async {
                            print("Bad 1 Login")
                            completion(nil, errorResponse)
                        }
                    }
                    catch {
                        DispatchQueue.main.async {
                            print("Bad 2 Login")

                            completion(nil, error)
                        }
                        
                    }
                }
            }
            task.resume()
        }
 
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
     
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            UdacityClient.Auth.sessionId = ""
            print("Log out")
            print(String(data: newData!, encoding: .utf8)!)
            completion()
        }
        task.resume()
      //  let body = LogoutRequest(sessionId: Auth.sessionId)
        //request.httpBody = try! JSONEncoder().encode(body)

        
    }

        class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void){
            let body: LoginRequest = LoginRequest(username: username, password: password)
            //request.httpBody = "{\"udacity\": {\"username\": \"account@domain.com\", \"password\": \"********\"}}".data(using: .utf8)
            taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: loginResponse.self, body: body, udacityApiFlag: true) { (response, error) in
                if let response = response {

                    Auth.registered = response.account.registered
                    Auth.userID = response.account.key
                    Auth.sessionId = response.session.id
                    completion(true, nil)
                }
                else {
                    completion(false, error)
                }
            }
        }

    class func getStudentsLocation(completion: @escaping ([student], Error?) -> Void){
        
         taskForGETRequest(url: Endpoints.studentlocation.url, responseType: getUserLocationResponse.self, udacityApiFlag: false) { (responseType, error) in
            if let responseType = responseType {
                completion(responseType.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getStudentData(){
        
          taskForGETRequest(url: Endpoints.getStudentData.url, responseType: currentUserResponse.self, udacityApiFlag: true) { (responseType, error) in
            guard let responseType = responseType else {return}
            guard let firstName = responseType.firstName else {return}
            newStudentInfo.firstName = firstName
            guard let lastName = responseType.lastName else {return}
            newStudentInfo.lastName = lastName
        }
    }

    class func addStudentLocation(firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void){
         let body = AddLocationtRequest(firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL)
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: AddLocationResponse.self, body: body, udacityApiFlag: false) { (response, error) in
            if  response != nil {
                completion(true, nil)
            }
            else {
                completion(false, error)
            }
        }
    }
}
