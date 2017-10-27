//
//  API.swift
//  KissAnime
//
//  Created by Nguyen Huy on 10/27/17.
//  Copyright © 2017 Nguyen Huy. All rights reserved.
//

import Foundation


class APILoveDays {
    class func getLoveDays(completion: @escaping (_ loveDays: String) -> ()){
        if let url = URL(string: "https://v96cxpygyi.execute-api.ap-southeast-1.amazonaws.com/cytest1/compare") {
            var req = URLRequest(url: url)
            req.httpMethod = "GET"
            URLSession.shared.dataTask(with: req, completionHandler: { (data, res, erro) in
                if let dataa = data {
                    do {
                        let json_object = try JSONSerialization.jsonObject(with: dataa, options: []) as? [String : String]
                        print(json_object as Any)
                        print(json_object?["love_days"] as Any)
                        DispatchQueue.main.async {
                            if let count = json_object?["love_days"] {
                                completion(count)
                            }
                        }
                    } catch {

                    }
                }
            }).resume()
        }

    }
}
