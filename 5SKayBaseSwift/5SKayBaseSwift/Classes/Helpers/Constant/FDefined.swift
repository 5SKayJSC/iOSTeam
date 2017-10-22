//
//  FDefined.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import UIKit

class FDefined: NSObject {
    
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
    
    static func fontRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
    static func fontBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size)!
    }
    
    static func fontLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: size)!
    }
    
    static func fontCondensedBold(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-CondensedBold", size: size)!
    }

    
    static let mainColor = UIColor(hexString: "#0099ee")
    static let grayColor = UIColor(hexString: "#e0e0e0")
}
