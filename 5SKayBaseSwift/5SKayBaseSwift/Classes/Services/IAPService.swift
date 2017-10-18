//
//  IAPService.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import Foundation
import StoreKit

@objc protocol IAPServiceDelegate {
    @objc func purchasing(productID: String)
    @objc func purchased(productID: String)
    @objc func failed(productID: String)
    @objc func restored(productID: String)
}

enum IAPType {
    case consumable
    case nonComsumable
    case autoSubscription
    case nonAutoSubscription
}

// MARK: IAPModel
class IAPModel: NSObject {
    // MARK: properties
    var identifier: String?
    var product: SKProduct?
    var type: IAPType = .consumable
    var dayOfSubscription: Int = 0  // only using with type = autoSubscription
    
    // MARK: init
    init(identifier1: String, type1: IAPType) {
        self.identifier = identifier1
        self.type = type1
    }
    
    init(identifier1: String, type1: IAPType, dayOfSubscription1: Int) {
        self.identifier = identifier1
        self.type = type1
        self.dayOfSubscription = dayOfSubscription1
    }
    
    init(identifier1: String, type1: IAPType, dayOfSubscription1: Int, product1: SKProduct) {
        self.identifier = identifier1
        self.type = type1
        self.dayOfSubscription = dayOfSubscription1
        self.product = product1
    }
    
    // MARK: private
    private func isWeek() -> Bool {
        return dayOfSubscription < 30
    }
    
    private func isMonth() -> Bool {
        return dayOfSubscription >= 30
    }
    
    private func isYear() -> Bool {
        return dayOfSubscription >= 365
    }
    
    // MARK: public
    func unit() -> String {
        if isWeek() {
            return "per week"
        }
        else if isMonth() {
            return "per month"
        }
        else if isYear() {
            return "per year"
        }
        return "per day"
    }
    
    func pricePerUnit() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product?.priceLocale
        
        if isWeek() {
            return formatter.string(from: (product?.price)!)!
        }
        else if isMonth() {
            let month = Float(dayOfSubscription / 30)
            let price = (product?.price.floatValue)! / month
            return formatter.string(from: NSNumber(value: price))!
        }
        else if isYear() {
            let year = Float(dayOfSubscription / 365)
            let price = (product?.price.floatValue)! / year
            return formatter.string(from: NSNumber(value: price))!
        }
        return formatter.string(from: (product?.price)!)!
    }
}

class IAPService: NSObject {
    fileprivate let loadingView = LoadingView()
    
    fileprivate var productsIDs = [IAPModel]()
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var delegate: IAPServiceDelegate?
    
    //
    fileprivate var receiptService = IAPReceiptService()
    var productsAvailable = [IAPModel]()
    
    //MARK: Shared Instance
    static let shared : IAPService = {
        let instance = IAPService()
        return instance
    }()
    
    override init() {
        // register IAP here
        productsIDs.removeAll()
        
    }
    
    func setup() {
        SKPaymentQueue.default().add(self)
        fetchAvailableProducts()
    }
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    private func fetchAvailableProducts()  {
        productsAvailable.removeAll()   // clean all
        
        //
        var array = [String]()
        for item in productsIDs {
            array.append(item.identifier!)
        }
        
        let productIdentifiers = NSSet(array: array)
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchase(iapItem: SKProduct, delegate: IAPServiceDelegate? = nil) {
        self.delegate = delegate
        
        if self.canMakePurchases() {
            for item in productsAvailable {
                if item.identifier == iapItem.productIdentifier {
                    let payment = SKPayment(product: item.product!)
                    SKPaymentQueue.default().add(payment)
                    
                    BLogInfo("PRODUCT TO PURCHASE: \(item.identifier!)")
                    return
                }
            }
        }
        else {
            UtilManage.showAlert(message: "Purchases are disabled in your device!", type: .ok, complete: nil)
        }
    }
    
    func restore() {
        if self.canMakePurchases() {
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
            
            loadingView.show()
        }
        else {
            UtilManage.showAlert(message: "Purchases are disabled in your device!", type: .ok, complete: nil)
        }
    }
    
}

// MARK: SKProductsRequestDelegate
extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (response.products.count > 0) {
            // sort list product by productsIDs
            for proID in productsIDs {
                for item in response.products {
                    if proID.identifier == item.productIdentifier {
                        proID.product = item
                        productsAvailable.append(proID)
                    }
                }
            }
        }
    }
}

// MARK: SKPaymentTransactionObserver
extension IAPService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for trans in transactions {
            switch trans.transactionState {
            case .purchasing:
                loadingView.show()
                
                if let del = delegate {
                    del.purchasing(productID: trans.payment.productIdentifier)
                }
            case .purchased:
                loadingView.dismiss()
                purchaseCompleted(transaction: trans)
                
                if let del = delegate {
                    del.purchased(productID: trans.payment.productIdentifier)
                }
            case .failed:
                loadingView.dismiss()
                purchaseFailed(transaction: trans)
                
                if let del = delegate {
                    del.failed(productID: trans.payment.productIdentifier)
                }
            case .restored:
                loadingView.dismiss()
                purchaseRestored(transaction: trans)
                
                if let del = delegate {
                    del.restored(productID: trans.payment.productIdentifier)
                }
            default:
                loadingView.dismiss()
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        loadingView.dismiss()
        UtilManage.showAlert(title: "Restore In App Purchase Fail", message: error.localizedDescription, type: .ok, complete: nil)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        var failed = false
        for trans in queue.transactions {
            switch trans.transactionState {
            case .purchased:
                UserDefaults.standard.set(true, forKey: trans.transactionIdentifier!)
                UserDefaults.standard.synchronize()
                break
            case .failed:
                failed = true
                break
            case .restored:
                
                break
            default: break
            }
        }
        
        if !failed {
            UtilManage.showAlert(title: "Restore In App Purchase success", message: "You've successfully restored your purchase!", type: .ok, complete: nil)
        }
    }
    
    func purchaseCompleted(transaction:SKPaymentTransaction){
        
        self.unlockContentForTransaction(trans: transaction)
        
        //Only after we have unlocked the content for the user
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func purchaseFailed(transaction:SKPaymentTransaction) {
        //In case of failed we need to check why it failed
        var message = ""
        if let error = transaction.error as? SKError {
            switch error {
            case SKError.clientInvalid:
                message = "User not allowed to make a payment request"
            case SKError.unknown:
                message = "Unkown error while proccessing SKPayment"
            case SKError.paymentCancelled:
                message = "User cancaled the payment request (Cancel)"
            case SKError.paymentInvalid:
                message = "The purchase id was not valid"
            case SKError.paymentNotAllowed:
                message = "This device is not allowed to make payments"
            default:
                break
            }
        }
        
        //Only after we have unlocked the content for the user
        SKPaymentQueue.default().finishTransaction(transaction)
        
        if message != "" {
            UtilManage.showAlert(title: "", message: message, type: .ok, complete: nil)
        }
    }
    
    
    func purchaseRestored(transaction:SKPaymentTransaction){
        self.unlockContentForTransaction(trans: transaction)
        
        //Only after we have unlocked the content for the user
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    
    
    //This function will unlock whatever the transaction have for product ID
    
    func unlockContentForTransaction(trans:SKPaymentTransaction){
        BLogInfo("Should unlock the content for product ID \(trans.payment.productIdentifier)")
        
        for item in productsAvailable {
            if item.type == .nonComsumable && item.identifier == trans.payment.productIdentifier {
                UserDefaults.standard.set(true, forKey: trans.transactionIdentifier!)
                UserDefaults.standard.synchronize()
                
                UtilManage.showAlert(title: "Payment In App Purchase success", message: "You've successfully unlocked the Premium version!", type: .ok, complete: nil)
            }
            else if item.type == .consumable && item.identifier == trans.payment.productIdentifier {
                
            }
            else if item.type == .autoSubscription && item.identifier == trans.payment.productIdentifier {
                receiptService.StartVaildatingReceipts()
            }
            else if item.type == .nonAutoSubscription && item.identifier == trans.payment.productIdentifier {
                
            }
        }
    }
}
