//
//  EmailService.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import Foundation
import MessageUI

class EmailService: NSObject {
    private let email_feedback = "support@5skay.net"
    
    //MARK: Shared Instance
    static let sharedInstance : EmailService = {
        let instance = EmailService()
        return instance
    }()
    
    override init() {
        
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.navigationBar.tintColor = UIColor.white
            composeVC.mailComposeDelegate = self
            
            let title = "[\(AboutApp.appName)] Feedback"
            var messeageBody = String()
            messeageBody.append("\n\n\n------------------------------------\n")
            messeageBody.append("System version: \(AboutApp.deviceVersion)\n")
            messeageBody.append("Model name: \(UIDevice.current.modelName)\n")
            messeageBody.append("App version: \(AboutApp.appVersion)\n")
            messeageBody.append("App build: \(AboutApp.appBuild)\n")
            
            composeVC.setToRecipients([email_feedback])
            composeVC.setSubject(title)
            composeVC.setMessageBody(messeageBody, isHTML: false)
            
            AppDelegate.shared.topMost.present(composeVC, animated: true, completion: nil)
        }
        else {
            UIAlertController.customInit().showDefault(title: "Notify", message: "You have not installed email.")
                    }
    }
}

// MARK: MFMailComposeViewControllerDelegate
extension EmailService: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
}
