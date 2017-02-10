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
    
    var baseURL: URL?
    var AccessToken: String?
    static let sharedInstance = TimeClient(baseURL: URL(string: "https://time-apps.herokuapp.com/api/")!)
    
    init(baseURL: URL) {
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
    func fetchToken(_ path: String, username: String, password: String, success: @escaping ()->(), failure: @escaping (_ error1: NSError?, _ error2: NSDictionary? )->()) {
        let targetURL = self.baseURL?.appendingPathComponent(path)
        let parameters = ["username": username, "password": password]
        let TokenRequest = Alamofire.request(targetURL!, method: .post, parameters: parameters)
        
        // Handling response with JSON format
        TokenRequest.responseJSON { response in
            switch response.result {
            case .success:
                let statusCode = response.response?.statusCode
                
                if let json = response.result.value as? NSDictionary {
                    
                    switch statusCode! {
                    case 200...299:
                        self.AccessToken = json["token"] as? String
                        self.keychain["AccessToken"] = self.AccessToken
                        success()
                    case 400...499:
                        print("JSON: \(json)")
                        print("Request error")
                        failure(nil, json)
                    case 500...599:
                        print("JSON: \(json)")
                        print("Server error")
                    default:
                        print("JSON: \(json)")
                        print("default error")
                    }
                }
            case .failure(let error):
                print("Cutom error when create service request in TimeClient in Failure case")
                failure(error as NSError?, nil)
            }
        }
    }
    
    func CheckInAndOutAPI(_ path: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, success: @escaping (NSDictionary)->(), failure: @escaping ()->()) {
        let targetURL = self.baseURL?.appendingPathComponent(path)
        let DataRequest = Alamofire.request(targetURL!, method: .post, parameters: parameters, headers: headers!)
        
        
        DataRequest.responseJSON { response in
            switch response.result {
            case .success:
                let statusCode = response.response?.statusCode
                
                if let json = response.result.value as? NSDictionary {
                    switch statusCode! {
                    case 200...299:
                        success(json)
                    case 400...499:
                        success(json)
                        print("Request error")
                    case 500...599:
                        success(json)
                        print("Server error")
                    default:
                        success(json)
                        print("default error")
                    }
                } else {
                    print("errors happened when trying to fetch data")
                }
            case .failure(let error):
                print("Cutom error when create service request in TimeClient")
                print(error.localizedDescription)
                failure()
            }
        }
    }
    

}
