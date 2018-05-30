//
//  APIManager.swift
//  Internet Archive
//
//  Created by Eagle19243 on 5/8/18.
//  Copyright © 2018 Eagle19243. All rights reserved.
//

import Foundation
import Alamofire

class APIManager: NSObject {
    static let sharedManager = APIManager()
    
    let BASE_URL = "https://archive.org/"
    let API_CREATE = "services/xauthn/?op=create"
    let API_LOGIN = "services/xauthn/?op=authenticate"
    let API_INFO = "services/xauthn/?op=info"
    let API_METADATA = "metadata/"
    
    let ACCESS = "trS8dVjP8dzaE296"
    let SECRET = "ICXDO78cnzUlPAt1"
    let API_VERSION = 1
    
    let HEADERS = [
        "User-Agent": "Wayback_Machine_iOS/\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)",
        "Wayback-Extension-Version": "Wayback_Machine_iOS/\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"]
    
    private func SendDataToService(params: [String: Any], operation: String, completion: @escaping ([String: Any]?) -> Void) {
        
        var parameters          = params
        parameters["access"]    = ACCESS
        parameters["secret"]    = SECRET
        parameters["version"]   = API_VERSION
        
        Alamofire
            .request("\(BASE_URL)\(operation)", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: HEADERS)
            .responseJSON{ (response) in
            
            switch response.result {
            case .success:
                if let json = response.result.value {
                    completion(json as? [String: Any])
                }
            case .failure:
                completion(nil)
                
            }
        }
    }
    
    // Register new Account
    func register(params: [String: Any], completion: @escaping ([String: Any]?) -> Void) {
        SendDataToService(params: params, operation: API_CREATE, completion: completion)
    }
    
    // Login
    func login(email: String, password: String, completion: @escaping ([String: Any]?) -> Void) {
        SendDataToService(params: [
            "email"     : email,
            "password"  : password
            ], operation: API_LOGIN, completion: completion)
    }
    
    // Get Account Info
    func getAccountInfo(email: String, completion: @escaping ([String: Any]?) -> Void) {
        SendDataToService(params: ["email": email], operation: API_INFO, completion: completion)
    }
    
    func search(query: String, options: [String: String], completion: @escaping (_ data: [String: Any]?, _ err: Int?) -> Void) {
        var str_option = "&output=json"
        
        for (key, value) in options {
            str_option += "&\(key)=\(value)"
        }
        
        let url = "\(BASE_URL)advancedsearch.php?q=\(query)\(str_option)"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Alamofire
            .request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, method: .get, encoding: URLEncoding.default, headers: HEADERS)
            .responseJSON{ (response) in
                
            switch response.result {
            case .success:
                if let json = response.result.value, let result = json as? [String: Any], let data = result["response"] as? [String: Any] {
                    completion(data, nil)
                }
            case .failure:
                completion(nil, 0)
            }
        }
    }
    
    func getCollections(collection: String, result_type: String, limit: Int?, completion: @escaping (_ collection: String, _ data: [[String: Any]]?, _ err: Int?) -> Void) {
        var options = [
            "rows" : "1",
            "fl[]" : "identifier,title,year,downloads,date"]
        
        if limit != nil {
            options["rows"] = "\(limit!)"
        }
        
        search(query: "collection:(\(collection)) And mediatype:\(result_type)", options: options) { (data, err) in
            if data != nil {
                if limit == nil, let numFound = data!["numFound"] as? Int {
                    if numFound == 0 {
                        // API.GetCollections - fail
                        completion(collection, nil, 0)
                    } else {
                        self.getCollections(collection: collection, result_type: result_type, limit: numFound, completion: completion)
                    }
                } else {
                    completion(collection, data!["docs"] as? [[String : Any]], nil)
                }
            } else {
                completion(collection, nil, err)
            }
        }

    }
    
    func getMetaData(identifier: String, completion: @escaping (_ data: [String: Any]?, _ err: Int?) -> Void) {
        Alamofire
            .request("\(BASE_URL)\(API_METADATA)\(identifier)", method: .get, encoding: URLEncoding.default, headers: HEADERS)
            .responseJSON{ (response) in
                
            switch response.result {
            case .success:
                if let json = response.result.value {
                    completion(json as? [String: Any], nil)
                }
            case .failure:
                completion(nil, 0)
            }
        }
    }
    
}


