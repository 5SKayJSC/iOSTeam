//
//  TableViewExtension.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import UIKit

public let kYPosition = CGFloat(44)

extension UITableView {
    
    func addIndicator(style: UIActivityIndicatorViewStyle, deltaCenterY: CGFloat = 0) {
        if self.viewWithTag(kTagIndicator) == nil {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: style)
            indicator.tag = kTagIndicator
            indicator.center = self.center
            indicator.centerY += deltaCenterY
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
            let font = FDefined.fontRegular(size: 15)
            let height = title.stringHeightWithMaxWidth(self.width, font: font)
            let label = UILabel(frame: CGRect(x: 15, y: kYPosition, width: UIScreen.width - 30, height: height + 40))
            label.tag = kTagLabel
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor(hexString: "#b5b5b5")
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
    
    func hideORShowVerticalScrollIndicator() {
        let contentHeight = self.contentSize.height
        let averageHeightRow = contentHeight / CGFloat(self.numberOfRows(inSection: 0))
        if contentHeight - averageHeightRow < UIScreen.height - CGFloat(64 + 44 + 49) {
            self.showsVerticalScrollIndicator = false
        } else {
            self.showsVerticalScrollIndicator = true
        }
    }
}
