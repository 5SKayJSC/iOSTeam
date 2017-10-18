//
//  IAPReceiptService.swift
//  OneTranslate
//
//  Created by Quynh Nguyen on 10/17/17.
//  Copyright © 2017 Quynh Nguyen. All rights reserved.
//

import Foundation
import StoreKit

#if DEBUG
let itunesURL = "https://sandbox.itunes.apple.com/verifyReceipt"
#else
let itunesURL = "https://buy.itunes.apple.com/verifyReceipt"
#endif

class IAPReceiptService: NSObject {
    private let K_ACTIVE_SUBCRIPTION = "K_ACTIVE_SUBCRIPTION"
    private let K_USER_TRIAL_PREIOD = "K_USER_TRIAL_PREIOD"
    private let K_DID_REFRESH_RECEIPT = "K_DID_REFRESH_RECEIPT"
    
    private let sharedSecret = ""
    
    //MARK: Shared Instance
    static let shared : IAPReceiptService = {
        let instance = IAPReceiptService()
        return instance
    }()
    
    override init() {
        super.init()
        
        if sharedSecret == "" {
            fatalError("You need input shareSecret from ITunes Connect")
        }
        
        //This function will be called when we init our IAPReceiptService in the IAPService CLass
        UserDefaults.standard.set(false, forKey: K_DID_REFRESH_RECEIPT)
        self.StartVaildatingReceipts()
        
    }
    
    // MARK: public
    func setup() {
        
    }
    
    // MARK: private
    func StartVaildatingReceipts(){
        do {
            _ = try self.getReceiptURL()?.checkResourceIsReachable()
            
            do {
                let receiptData = try Data(contentsOf: self.getReceiptURL()!)
                
                //Start vaildating the receipt with iTunes server
                self.vaildateData(data: receiptData)
                
                BLogInfo("Receipt exist")
                
            } catch {
                BLogInfo("Not able to get data from URL")
            }
        } catch {
            
            //Now if we try to load the receipt from local and for some reason the url doesn't exist, we need to make SKReceiptRefreshRequest we mentioned ealier
            guard UserDefaults.standard.bool(forKey: K_DID_REFRESH_RECEIPT) == false else {
                BLogInfo("Stopping after second attempt")
                return
            }
            
            UserDefaults.standard.set(true, forKey: K_DID_REFRESH_RECEIPT)
            
            let receiptRequest = SKReceiptRefreshRequest()
            receiptRequest.delegate = self
            receiptRequest.start()
            
            BLogInfo("Receipt URL Doesn't exist \(error.localizedDescription)")
        }
    }
    
    private func getReceiptURL() -> URL? {
        return Bundle.main.appStoreReceiptURL
    }
    
    private func vaildateData(data:Data) {
        //First we need to encode the data to base64
        let receiptsString = data.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        
        //Now we need to wrap our data with our Secret Shared and then send it to apple server
        var dic:[String:AnyObject] = [:]
        
        dic["receipt-data"] = receiptsString as AnyObject
        dic["password"] = sharedSecret as AnyObject?
        
        //Serialize the dictionary to JSON data
        let json = try! JSONSerialization.data(withJSONObject: dic, options: [])
        
        //Create a URLRequest
        var urlRequest = URLRequest(url: URL(string: itunesURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = json
        
        //Let's use the shared URLSession to send the request
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            if let receiptData = data {
                self.handleData(data: receiptData)
            } else {
                BLogInfo("Error vaildating receipt with itunes connect")
            }
        }
        
        //WE need to tell the task to start
        task.resume()
    }
    
    //Let's create a function handle our retured data
    private func handleData(data:Data){
        //First we need to decode the data back to JSON
        guard let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary else {
            BLogInfo("Not able to encode jsonObject")
            return
        }
        
        //Let's check for the status value
        guard let status = json?["status"] as? NSNumber else { return }
        
        if status == 0 {
            //status OK
            //Let's get the receipt dictionary
            let receipt = json?["receipt"] as! NSDictionary
            
            //Now let's get the In-App purchases
            guard let allInApps = receipt["in_app"] as? [NSDictionary] else {
                BLogInfo("No In-App purchases available")
                return
            }
            
            //Now we have to loop through each In-App and check for the values we discussed ealier
            for inApp in allInApps {
                //Since we will only be interested in subscriptions
                guard let expiryDate = inApp["expires_date_ms"] as? NSString else {
                    //It's not a subscription production since it has no expiry_date_ms field
                    //If it's not subscription then skip this item
                    continue
                }
                
                //let purchaseDate = (inApp["purchase_date_ms"] as? NSString)?.doubleValue
                //let productID = inApp["product_id"]
                //let transactionID = inApp["transaction_id"]
                let isTrial = inApp["is_trial_period"] as? NSString
                
                self.checkSubscriptionStatus(date: Date.init(timeIntervalSince1970: expiryDate.doubleValue / 1000))
                self.saveTrial(isTrial: isTrial!.boolValue)
            }
            
            //Let's post a notification when the receipt is updated so we can update our UI the table view to see if user is subscribed
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "ReceiptDidUpdated"), object: nil)
            
        } else {
            BLogInfo("Error vaildating receipts - data not correct")
        }
    }
    
    private func checkSubscriptionStatus(date:Date) {
        //In this function we will check for the expiry date of the subscription and see if it is newer than now, if so, then the user is subscribed to this product
        let calendar = Calendar.current
        let now = Date()
        let order = calendar.compare(now, to: date, toGranularity: .minute)
        
        switch order {
        case .orderedAscending, .orderedSame:
            BLogInfo("User subscribed")
            self.saveActiveSubscription(date: date)
        case .orderedDescending:
            BLogInfo("User subscription has expired")
        }
    }
    
    private func saveActiveSubscription(date:Date) {
        //In our app example, we will only have one active subscription at a time. So there will be only one subscription either active or not
        UserDefaults.standard.set(date, forKey: K_ACTIVE_SUBCRIPTION)
        UserDefaults.standard.synchronize()
    }
    
    private func saveTrial(isTrial:Bool) {
        UserDefaults.standard.set(isTrial, forKey: K_USER_TRIAL_PREIOD)
        UserDefaults.standard.synchronize()
        
    }
    
    //Let's make a handy function to tell us only if the user is Subscribed or not
    var isSubscribed:Bool {
        guard let currentActiveSubscription = UserDefaults.standard.object(forKey: K_ACTIVE_SUBCRIPTION) as? Date else {
            return false
        }
        
        //This way we check for the date everytime we call this variable
        return currentActiveSubscription.timeIntervalSince1970 > Date().timeIntervalSince1970 // NOW
    }
    
    //Now let's make a variable to tell us if the user is on trial period
    var isTrial:Bool {
        return UserDefaults.standard.bool(forKey: K_USER_TRIAL_PREIOD)
    }
}

extension IAPReceiptService: SKRequestDelegate {
    func requestDidFinish(_ request: SKRequest) {
        //Now if the refresh request is finished then we need to call our startVaildating function again to start the whole process again. But in order to not stuck in a loop if the receipt never exist we need to add some extra logic
        self.StartVaildatingReceipts()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        BLogInfo("Error refreshing receipt \(error.localizedDescription)")
    }
}
