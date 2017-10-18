//
//  UIAlertViewControllerExtensions.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func showDefault(title: String, message: String, complete: @escaping () -> ()) {
        
        self.message = message
        self.title = title
        
        let alertAction = UIAlertAction(title: LANGTEXT(key: "OK"), style: .cancel) { (action) in
            
            complete()
        }
        self.addAction(alertAction)
        
        UIApplication.topViewController().present(self, animated: true) {
            
        }
    }
    
    func showDefault2(title: String, message: String, complete: @escaping (Bool) -> ()) {
        
        self.message = message
        self.title = title
        
        let okAction = UIAlertAction(title: LANGTEXT(key: "OK"), style: .default) { (action) in
            
            complete(true)
        }
        
        let cancelAction = UIAlertAction(title: LANGTEXT(key: "CANCEL"), style: .cancel) { (action) in
            
            complete(false)
        }
        
        self.addAction(okAction)
        self.addAction(cancelAction)
        
        UIApplication.topViewController().present(self, animated: true) {
            
        }
    }
    
    func showDefault(title: String, message: String) {
        
        self.message = message
        self.title = title
        
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            
        }
        self.addAction(alertAction)
        
        UIApplication.topViewController().present(self, animated: true) {
        }
    }
    
    class func customInit() -> UIAlertController {
        
        return UIAlertController(title: "", message: "", preferredStyle: .alert)
    }
}

extension UIApplication {
    class func topViewController() -> UIViewController! {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return nil
    }
}

