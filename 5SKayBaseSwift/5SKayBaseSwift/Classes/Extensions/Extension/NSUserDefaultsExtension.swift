//
//  NSUserDefaultsExtension.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setString(_ string: String, forKey: String) {
        set(string, forKey: forKey)
    }
    
    func setDate(_ date: Date, forKey: String) {
        set(date, forKey: forKey)
    }
    
    func dateForKey(_ string: String) -> Date? {
        return object(forKey: string) as? Date
    }
}
