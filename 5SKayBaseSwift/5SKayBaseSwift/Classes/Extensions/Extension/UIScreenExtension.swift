//
//  UIScreenExtension.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//


import UIKit

public extension UIScreen {
    class var size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    class var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    class var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    class var orientationSize: CGSize {
        let systemVersion = (UIDevice.current.systemVersion as NSString).floatValue
        let isLand: Bool = UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
        return (systemVersion > 8.0 && isLand) ? UIScreen.SwapSize(self.size) : self.size
    }
    
    class var orientationWidth: CGFloat {
        return self.orientationSize.width
    }
    
    class var orientationHeight: CGFloat {
        return self.orientationSize.height
    }
    
    class var DPISize: CGSize {
        let size: CGSize = UIScreen.main.bounds.size
        let scale: CGFloat = UIScreen.main.scale
        return CGSize(width: size.width * scale, height: size.height * scale)
    }
    
    class func SwapSize(_ size: CGSize) -> CGSize {
        return CGSize(width: size.height, height: size.width)
    }
    
    /**
     Calculate screen size width by removing lateral margins
     
     - parameter margin: margin to apply to the final window
     
     - returns: the screen size without the margins
     */
    class func screnSize(byAddingMargins margin: Int) -> CGFloat {
        return UIScreen.width - CGFloat(margin * 2)
    }
    
    /**
     Detect if the current device has wide screen
     */
    class func isWideScreen() -> Bool {
        return UIScreen.height >= 568.0
    }
}
