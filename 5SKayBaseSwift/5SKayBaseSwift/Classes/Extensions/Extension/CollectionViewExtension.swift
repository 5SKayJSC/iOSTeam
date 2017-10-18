//
//  CollectionViewExtension.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//


import UIKit

public let kTagLabel = 9999999
public let kTagIndicator = 99999999

extension UICollectionView {
    
    func addIndicator(style: UIActivityIndicatorViewStyle) {
        if self.viewWithTag(kTagIndicator) == nil {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: style)
            indicator.tag = kTagIndicator
            indicator.center = self.center
            self.addSubview(indicator)
            indicator.startAnimating()
        }
    }
    
    func removeIndicator() {
        self.subviews.forEach {
            $0.viewWithTag(kTagIndicator)?.removeFromSuperview()
        }
    }
    
    func addLabel(_ title: String) {
        if self.viewWithTag(kTagLabel) == nil {
            let font = FDefined.fontRegular(size: 14)
            let height = title.stringHeightWithMaxWidth(self.width, font: font)
            let label = UILabel(frame: CGRect(x: 15, y: 20, width: UIScreen.width - 30, height: height + 40))
            label.tag = kTagLabel
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.gray
            label.text = title
            label.font = font
            label.numberOfLines = 0
            label.textAlignment = .center
            self.addSubview(label)
        }
    }
    
    func removeLabel() {
        self.subviews.forEach {
            $0.viewWithTag(kTagLabel)?.removeFromSuperview()
        }
    }
}
