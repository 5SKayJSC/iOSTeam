//
//  File.swift
//  delegate
//
//  Created by Nguyen Huy on 8/10/17.
//  Copyright © 2017 Nguyen Huy. All rights reserved.
//

import UIKit

protocol ChangeText {
    func protocolChangeText(string: String)
}
class API {
    var delegate: ChangeText?
    func count(){
        
        for i in 0...10{
            print(i)
        }
        delegate?.protocolChangeText(string: "Hello! I'm running!")
    }
}
