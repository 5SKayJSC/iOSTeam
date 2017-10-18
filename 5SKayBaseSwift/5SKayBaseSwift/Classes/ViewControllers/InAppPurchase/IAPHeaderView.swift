//
//  IAPHeaderView.swift
//  OneTranslate
//
//  Created by Quynh Nguyen on 10/17/17.
//  Copyright © 2017 Quynh Nguyen. All rights reserved.
//

import UIKit
import SnapKit

class IAPHeaderView: BaseReusableCollectionView {
    private let labelTitle:UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = UIColor(hex: 0x1e1f22)
        view.text = "Upgrade to Premium and unlock all features"
        view.font = UIFont.boldSystemFont(ofSize: 15)
        return view
    }()
    
    // MARK: dealloc
    deinit { BLogInfo("") }
    
    // MARK: init
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initComponent()
        initSubviews()
        initConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: private
    private func initComponent() {
        self.backgroundColor = UIColor.clear
        
    }
    
    private func initSubviews() {
        self.addSubview(labelTitle)
    }
    
    private func initConstraint() {
        labelTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
}
