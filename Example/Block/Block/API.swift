//
//  API.swift
//  Block
//
//  Created by Nguyen Huy on 8/10/17.
//  Copyright © 2017 Nguyen Huy. All rights reserved.
//

import UIKit

typealias  completeBlock = (_ string: String) -> ()

class API {
    func getString(complete: @escaping(completeBlock)) -> Void {
        
        
            for i in  0...5{
                print(i)
                sleep(1)
            }
            
        
        complete("Hello")
    }
    
}
class test {
    var stringHello = " Helllo world"
    func getHello(text: String,complete: @escaping(completeBlock)) -> Void {
        
            complete("\(stringHello) ! I finish \(text)   ")
        
    }
}
