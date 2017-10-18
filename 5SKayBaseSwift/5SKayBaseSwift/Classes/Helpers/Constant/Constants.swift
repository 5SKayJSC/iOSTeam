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
import RealmSwift
import ReachabilitySwift
import NVActivityIndicatorView


// MARK: CompletionHandler
typealias CompletionHandler = (Bool, Int, Any?) -> ()

// MARK: - Public constant
let realmInstant = try! Realm()

// Standard UserDefault
public let SETTINGs = UserDefaults.standard

// define font
public let kRegularFont = UIFont(name: "Hiragino Sans", size: 13)
public let kBarButtonItemFont = UIFont.systemFont(ofSize: 15)
public let kTitleControllerFont = UIFont.boldSystemFont(ofSize: 17)

// Button color
public let kButtonFavoriteColor = UIColor(234, 83, 72)
public let kButtonUnFavoriteColor = UIColor(67, 67, 67)
public let kButtonBackgroundColor = UIColor(245, 242, 230)
public let kTextColor = UIColor(hexString: "#383838")
public let kMainColor = UIColor(hexString: "#2597DC")
public let kRedColor = UIColor(hexString: "#E34D3F")
public let kHeaderColor = UIColor(hexString: "#2597dc")
public let kAvatarBorderColor = UIColor(hexString: "#bbe8ff")
public let kLineColor = UIColor(hexString: "#CECED2")

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

// MARK: - Loading func
let activityData = ActivityData(size: nil, message: nil, messageFont: nil, type: .ballClipRotate, color: nil, padding: nil, displayTimeThreshold: 30, minimumDisplayTime: nil)

func showLoading() {
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
}

func hideLoading() {
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
}

