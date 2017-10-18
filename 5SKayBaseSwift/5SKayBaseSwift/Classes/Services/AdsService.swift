//
//  AdsService.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import Foundation
import GoogleMobileAds

typealias AdsLoadComplete = (_ succes: Bool, _ data: Any?) -> ()

enum AdmobNetwork: String {
    case id_app = "ca-app-pub-3940256099942544~1458002511"
    case id_banner = "ca-app-pub-3940256099942544/2934735716"
    case id_popup = "ca-app-pub-3940256099942544/4411468910"
}

extension Notification.Name {
    static let TOUCH_BUTTON = Notification.Name("NOTIFY_TOUCH_BUTTON")
}

final class AdsService: NSObject {
    let ADS_VIEW_TAG = 99999
    let NUMBER_TOUCH_BUTTON_SHOW_POPUP_MAX = 3
    
    var allow_show_banner = true
    var allow_show_interstitial = true
    
    fileprivate var interstitial: GADInterstitial?
    fileprivate var rootViewController: UIViewController?
    fileprivate var complete: AdsLoadComplete?
    
    fileprivate var number_touch_button: Int = 0
    
    //MARK: Shared Instance
    static let shared : AdsService = {
        let instance = AdsService()
        return instance
    }()
    
    
    //MARK: Init
    override init() {
        // Use Firebase library to configure APIs.
        //FIRApp.configure()
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.configure(withApplicationID: AdmobNetwork.id_app.rawValue)
        
    }
    
    func setup() {
        // add notify
        NotificationCenter.default.addObserver(self, selector: #selector(touchButtonNotification), name: Notification.Name.TOUCH_BUTTON, object: nil)
    }
    
    // MARK: notify
    @objc func touchButtonNotification() {
        if (!allow_show_interstitial) { return }
        
        // Can disable ads when buy IAP here
        
        //
        number_touch_button += 1
        
        if (number_touch_button >= NUMBER_TOUCH_BUTTON_SHOW_POPUP_MAX) {
            if let ad = interstitial {
                if ad.isReady {
                    ad.present(fromRootViewController: AppDelegate.shared.topMost)
                    self.number_touch_button = 0
                }
                return
            }
        }
        
        if self.interstitial == nil {
            admob_popup(rootVC: AppDelegate.shared.topMost, complete: nil)      // load ads
        }
    }
    
    //MARK: private
    fileprivate func admob_request() -> GADRequest {
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID, "27e44354d4c83f17a1423f0d121484bc"]
        return request
    }
    
    //MARK: public
    func admod_banner(rootVC: UIViewController, superView: UIView, complete: AdsLoadComplete?) -> GADBannerView?
    {
        if (!allow_show_banner) {
            if let block = complete { block(false, nil) }
            return nil
        }
        
        // Can disable ads when buy IAP here
        
        
        // clear all ads in superview
        for view in superView.subviews {
            if view.tag == ADS_VIEW_TAG {
                view.removeFromSuperview()
            }
        }
        
        self.complete = complete
        
        //
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = AdmobNetwork.id_banner.rawValue
        bannerView.delegate = self
        bannerView.rootViewController = rootVC
        bannerView.tag = ADS_VIEW_TAG
        superView.addSubview(bannerView)
        
        var frame = bannerView.frame
        frame.origin.x = (superView.frame.size.width - frame.size.width) / 2
        frame.origin.y = 0
        
        if superView.frame.size.height > 0 {
            frame.origin.y = (superView.frame.size.height - frame.size.height) / 2
        }
        
        bannerView.frame = frame
        bannerView.load(self.admob_request())
        
        return bannerView
    }
    
    func admob_popup(rootVC: UIViewController, complete: AdsLoadComplete?)
    {
        self.rootViewController = rootVC
        self.complete = complete
        
        self.interstitial = GADInterstitial(adUnitID: AdmobNetwork.id_popup.rawValue)
        self.interstitial?.delegate = self
        self.interstitial?.load(self.admob_request())
    }
    
}

extension AdsService: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        if let block = complete {
            block(true, bannerView)
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        BLogInfo(error.localizedDescription)
        if let block = complete {
            block(false, bannerView)
        }
    }
}

extension AdsService: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if ad.isReady {
            BLogInfo("Ready show interstitial")
        }
        
        if let block = complete {
            block(ad.isReady, ad)
        }
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        BLogInfo(error.localizedDescription)
        
        self.interstitial = nil
        if let block = complete {
            block(false, ad)
        }
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.interstitial = nil
    }
}
