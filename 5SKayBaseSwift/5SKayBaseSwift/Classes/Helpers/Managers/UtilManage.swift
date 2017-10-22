//
//  UtilManage.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/16/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import UIKit
import SystemConfiguration

public enum BAlertType: Int {
    case ok = 0
    case yesNo
    case cancel
}

public enum BButtonResult: Int {
    case ok = 0
    case yes
    case no
    case cancel
}

private enum ActionTitle: String {
    case ok = "Ok"
    case yes = "Yes"
    case no = "No"
    case cancel = "Cancel"
}

typealias alertTapHandler = (_ alertView: UIAlertController, _ button: BButtonResult) -> ()
typealias actionSheetTapHandler = (_ titleSelected: String, _ button: BButtonResult?) -> ()

class UtilManage: NSObject {
    
    // MARK: check network
    class func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let result = (isReachable && !needsConnection)
        
        return result
    }
    
    // MARK: share
    class func shareSocial(text: String, sourceView:UIView?, viewcontroller:UIViewController) {
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if activity.popoverPresentationController != nil {
            activity.popoverPresentationController?.sourceView = sourceView
        }
        
        viewcontroller.present(activity, animated: true, completion: nil)
    }
    
    
}
