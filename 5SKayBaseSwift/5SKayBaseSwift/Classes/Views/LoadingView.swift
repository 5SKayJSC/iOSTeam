//
//  LoadingView.swift
//  OneTranslate
//
//  Created by Quynh Nguyen on 10/16/17.
//  Copyright © 2017 Quynh Nguyen. All rights reserved.
//

import UIKit
import SnapKit

class LoadingView: UIView {
    var message:String = "" {
        willSet {
            self.labelMessage.text = newValue
        }
    }
    
    // MARK: properties
    private let indicatorView:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        return view
    }()
    
    private let labelMessage:UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.textAlignment = .center
        view.textColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 16)
        view.numberOfLines = 0
        return view
    }()
    
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
    
    convenience init(message: String) {
        self.init(frame: .zero)
        self.message = message
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: dealloc
    deinit { BLogInfo("") }
    
    // MARK: private
    private func initComponent() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    private func initSubviews() {
        self.addSubview(indicatorView)
        self.addSubview(labelMessage)
    }
    
    private func initConstraint() {
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        labelMessage.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY).offset(30)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: public
    func show() {
        self.frame = UIScreen.main.bounds
        self.alpha = 0
        
        AppDelegate.shared.window?.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        
        indicatorView.startAnimating()
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    // MARK: events
    
    
    
}
