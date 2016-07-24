//
//  TimeClient.swift
//  timeApp-iOS
//
//  Created by dong liang on 7/20/16.
//  Copyright © 2016 kanic. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess
import MBProgressHUD

class TimeClient: NSObject {
    
    let keychain = Keychain(service: "com.kanic.timeApp-iOS")
    
    var baseURL: NSURL?
    var AccessToken: String?
    static var sharedInstance : TimeClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : TimeClient? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = TimeClient(baseURL: NSURL(string: "http://127.0.0.1:8000/api/")!)
        }
        return Static.instance!
    }
    
    init(baseURL: NSURL) {
        self.baseURL = baseURL
    }
    
    /*
     // MARK: - Fetching Token
     
     // Using this method to fetch token for any user.
     // - Parameter path: Api url
     // - Parameter username: Username
     // - Parameter password: Password
     // - Parameter success: callback function when request succeeds
     // - Parameter failure: callback function when request fails
     */
    func fetchToken(path: String, username: String, password: String, success: ()->(), failure: (error1: NSError?, error2: NSDictionary? )->()) {
        let targetURL = self.baseURL?.URLByAppendingPathComponent(path)
        let parameters = ["username": username, "password": password]
        let TokenRequest = Alamofire.request(.POST, targetURL!, parameters: parameters)
        
        // Handling response with JSON format
        TokenRequest.responseJSON { response in
            switch response.result {
            case .Success:
                let statusCode = response.response?.statusCode
                
                if let json = response.result.value as? NSDictionary{
                    
                    switch statusCode! {
                    case 200...299:
                        self.AccessToken = json["token"] as? String
                        print(self.AccessToken)
                        self.keychain["AccessToken"] = self.AccessToken
                        success()
                    case 400...499:
                        print("JSON: \(json)")
                        print("Request error")
                        failure(error1: nil, error2: json)
                    case 500...599:
                        print("JSON: \(json)")
                        print("Server error")
                    default:
                        print("JSON: \(json)")
                        print("default error")
                    }
                }
            case .Failure(let error):
                print("Cutom error when create service request in TimeClient in Failure case")
                print(error.localizedDescription)
                failure(error1: error, error2: nil)
            }
        }
    }
    
    func CheckInAndOutAPI(path: String, parameters: [String: AnyObject]? = nil, headers: [String: String]? = nil, success: ([NSDictionary])->(), failure: ()->()) {
        let targetURL = self.baseURL?.URLByAppendingPathComponent(path)
        let DataRequest = Alamofire.request(.POST, targetURL!, parameters: parameters, headers: headers)
        
        DataRequest.responseJSON { response in
            switch response.result {
            case .Success:
                let statusCode = response.response?.statusCode
                
                if let json = response.result.value as? [NSDictionary] {
                    switch statusCode! {
                    case 200...299:
                        success(json)
                    case 400...499:
                        print("JSON: \(json)")
                        print("Request error")
                    case 500...599:
                        print("JSON: \(json)")
                        print("Server error")
                    default:
                        print("JSON: \(json)")
                        print("default error")
                    }
                } else {
                    print("errors happened when trying to fetch data")
                }
            case .Failure(let error):
                print("Cutom error when create service request in TimeClient")
                print(error.localizedDescription)
                failure()
            }
        }
    }
    

}
