//
//  APIService.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import Foundation

fileprivate enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

// if success is true -> any is data. else -> any is error
typealias APICompletion = (_ succes: Bool, _ data: Any?) -> ()

class APIService: NSObject {
    private let TIMEOUT_REQUEST:TimeInterval = 30
    
    //MARK: Shared Instance
    static let shared:APIService = APIService()
    
    //MAKR: private
    fileprivate func request(urlString: String,
                             param: [String: Any]?,
                             method: HTTPMethod,
                             complete: APICompletion?)
    {
        self.request(urlString: urlString, param: param, method: method, showLoading: true, complete: complete)
    }
    
    fileprivate func request(urlString: String,
                             param: [String: Any]?,
                             method: HTTPMethod,
                             showLoading: Bool,
                             complete: APICompletion?)
    {
        self.displayLoading(showLoading)
        
        var request:URLRequest!
        
        // set method & param
        if method == .get {
            if let parameterString = param?.stringFromHttpParameters() {
                request = URLRequest(url: URL(string:"\(urlString)?\(parameterString)")!)
            }
            else {
                request = URLRequest(url: URL(string:urlString)!)
            }
        }
        else if method == .post {
            request = URLRequest(url: URL(string:urlString)!)
            
            // content-type
            let headers: Dictionary = ["Content-Type": "application/json"]
            request.allHTTPHeaderFields = headers
            
            let parameterString = param?.stringFromHttpParameters()
            if parameterString != nil {
                request.httpBody = parameterString?.data(using: .utf8)
            }
        }
        
        request.timeoutInterval = TIMEOUT_REQUEST
        request.httpMethod = method.rawValue
        
        //
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            self.hideLoading(showLoading)
            
            // check for fundamental networking error
            guard let data = data, error == nil else {
                if let block = complete {
                    block(false, error)
                }
                
                return
            }
            
            // check for http errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200, let res = response {
                BLogInfo("statusCode should be 200, but is \(httpStatus.statusCode)")
                BLogInfo("response = \(res)")
            }
            
            if let block = complete {
                if let json = self.dataToJSON(data: data) {
                    BLogInfo("response json = \(json)")
                    block(true, json)
                }
                else if let responseString = String(data: data, encoding: .utf8) {
                    BLogInfo("response string = \(responseString)")
                    block(true, error)
                }
            }
        }
        task.resume()
    }
    
    private func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: [])
        } catch let myJSONError {
            BLogError("convert to json error: \(myJSONError)")
        }
        return nil
    }
    
    private func displayLoading(_ allow:Bool) {
        //        if allow {
        //            if let view = UIApplication.shared.keyWindow {
        //                DispatchQueue.main.async {
        //                    MBProgressHUD.showAdded(to:view , animated: true)
        //                }
        //            }
        //        }
    }
    
    private func hideLoading(_ allow:Bool) {
        //        if allow {
        //            if let view = UIApplication.shared.keyWindow {
        //                DispatchQueue.main.async {
        //                    MBProgressHUD.hide(for:view , animated: true)
        //                }
        //            }
        //        }
    }
}

// MARK: API define
extension APIService {
    
}
