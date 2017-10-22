//
//  Constants.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//


import Foundation
import UIKit
import Localize_Swift


// MARK: CompletionHandler
typealias CompletionHandler = (Bool, Int, Any?) -> ()

// MARK: - Public constant

// Standard UserDefault
public let SETTINGs = UserDefaults.standard



// App Url
public let kAppStoreID  = 1152372911 // Change this one to my app ID
public let kAppStoreURLFormat = "itms-apps://itunes.apple.com/app/id"

// Some Constant
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
public let OS_VERSION = UIDevice.current.systemVersion

class Constants {
    //MARK: - Contants will use in all class
    static var deviceToken : String? {
        
        get {
            
            if let value = SETTINGs.value(forKey: "DEVICE_TOKEN") {
                
                return value as? String
            } else {
                return ""
            }
        }
        
        set(newValue) {
            
            if newValue?.isEmpty == false {
                SETTINGs.set(newValue, forKey: "DEVICE_TOKEN")
                SETTINGs.synchronize()
            }
        }
    }
    
    internal class func radians(degrees: CGFloat)-> CGFloat{
        return (degrees * CGFloat(Double.pi)/180)
    }
    
    internal class func degrees(radians: CGFloat)-> CGFloat{
        return (radians * 180/CGFloat(Double.pi))
    }
    
}

// MARK: - UserDefault
public let kDeviceToken = "kDeviceToken"
public let kAccessToken = "kAccessToken"
public let kLocationLat = "kLocationLat"
public let kLocationLong = "kLocationLong"
public let kDeviceUUID = "kDeviceUUID"
public let kVendorDeviceUUID = "kVendorDeviceUUID"

// MARK: - Standard UserDefault
public let standardUserDefaults = UserDefaults.standard
public let kUserInfoKey             = "userInfo"

// MARK: - Public Constants and Function
public let kTimeoutIntervalForRequest = TimeInterval(15)
public let kScreenSize = UIScreen.main.bounds
public let kDQErrorDomain = "kDQErrorDomain"
public let kAccessTokenErrorCode = 401
public let timeToDissmissHUD = 60.0
public let kImageQualityUpload = CGFloat(0.7)
public let kImageSizeUpload = CGFloat(640)
public let kMinBusinessTime = 8    // hour unit
public let kMaxBusinessTime = 15   // hour unit
public let expandToken = "Đọc tiếp"

public var kCommonTime: Int64 = 0

// MARK: - Network
public var isInternetConnected = true

// MARK: Compare version string
func isMathedVersion(currentVersion: String, newVersion: String) -> Bool {
    //        return true
    switch currentVersion.compare(newVersion, options: NSString.CompareOptions.numeric) {
    case .orderedSame, .orderedDescending:
        
        return true
    case .orderedAscending:
        
        return false
    }
}

// MARK: Local string function
func LANGTEXT(key: String)-> String {
    return key.localized()
}

func getCurrentLangtext() -> String {
    return Localize.currentLanguage()
}

func setLanguage(language: String) {
    
    let local = Localize.availableLanguages()
    
    if local.contains(language) {
        Localize.setCurrentLanguage(language)
    }
}

