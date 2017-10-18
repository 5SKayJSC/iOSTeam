//
//  IAPFooterView.swift
//  OneTranslate
//
//  Created by Quynh Nguyen on 10/17/17.
//  Copyright © 2017 Quynh Nguyen. All rights reserved.
//

import UIKit
import SnapKit

class IAPFooterView: BaseReusableCollectionView {
    private let labelTitle:UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = UIColor(hex: 0x807f85)
        view.text = "Automatic renewal, cancel anytime through the App Store. See our Terms & Conditions and Privacy Policy"
        view.font = UIFont.systemFont(ofSize: 15)
        return view
    }()
    
    private let btnRestore:UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Restore Purchases", for: .normal)
        view.setTitleColor(UIColor(hex: 0x67bbff), for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15)
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
        
        btnRestore.addTarget(self, action: #selector(restoreClick(_:)), for: .touchUpInside)
    }
    
    private func initSubviews() {
        self.addSubview(labelTitle)
        self.addSubview(btnRestore)
    }
    
    private func initConstraint() {
        labelTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalTo(self.btnRestore.snp.top).offset(-5)
        }
        
        btnRestore.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
    }

    // MARK: events
    @objc private func restoreClick(_ sender:Any) {
        IAPService.shared.restore()
    }
}
