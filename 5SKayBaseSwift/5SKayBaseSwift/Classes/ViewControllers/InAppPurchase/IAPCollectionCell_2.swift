//
//  IAPCollectionCell_2.swift
//  OneTranslate
//
//  Created by Quynh Nguyen on 10/17/17.
//  Copyright © 2017 Quynh Nguyen. All rights reserved.
//

import UIKit

class IAPCollectionCell_2: BaseCollectionCell {
    private var iapModel: IAPModel?
    
    var isBestValue:Bool = false {
        willSet {
            self.labelBestValue.snp.remakeConstraints { (make) in
                make.left.top.right.equalToSuperview().offset(0)
                make.height.equalTo(newValue ? 20 : 0)
            }
            
            self.viewContainer.layer.borderWidth = newValue ? 1 : 0
            self.contentView.layer.borderColor = newValue ? UIColor(hex: 0xfeaa36).cgColor : UIColor.black.withAlphaComponent(0.2).cgColor
        }
    }
    
    // MARK: properties view
    private let viewContainer:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let labelBestValue:UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 13)
        view.textAlignment = .left
        view.numberOfLines = 1
        view.backgroundColor = UIColor(hex: 0xfeaa36)
        view.textColor = UIColor.white
        view.text = "  BEST VALUE"
        view.layer.cornerRadius = 2
        return view
    }()
    
    private let labelTitle:UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textAlignment = .left
        view.numberOfLines = 1
        view.textColor = UIColor(hex: 0x1e1f22)
        return view
    }()
    
    private let labelDetail:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.textAlignment = .left
        view.numberOfLines = 0
        view.textColor = UIColor(hex: 0x807f85)
        return view
    }()
    
    private let labelPrice:UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textAlignment = .right
        view.numberOfLines = 1
        view.textColor = UIColor(hex: 0x4ea3e4)
        return view
    }()
    
    private let labelUnderPrice:UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 14)
        view.textAlignment = .right
        view.numberOfLines = 1
        view.textColor = UIColor(hex: 0x807f85)
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
    
    // MARK: layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //self.contentView.dropShadow(color: .black, opacity: 0.4, offSet: CGSize(width: -1, height: 1), radius: 2, scale: true)
    }
    
    // MARK: private
    private func initComponent() {
        self.backgroundColor = UIColor.white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        self.addGestureRecognizer(tapGesture)
        
        self.contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 2
        viewContainer.layer.borderColor = UIColor(hex: 0xfeaa36).cgColor
    }
    
    private func initSubviews() {
        self.contentView.addSubview(viewContainer)
        viewContainer.addSubview(labelBestValue)
        viewContainer.addSubview(labelTitle)
        viewContainer.addSubview(labelDetail)
        viewContainer.addSubview(labelPrice)
        viewContainer.addSubview(labelUnderPrice)
    }
    
    private func initConstraint() {
        viewContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        labelBestValue.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview().offset(0)
            make.height.equalTo(0)
        }
        
        labelTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(self.labelPrice.snp.left).offset(-10)
            make.centerY.equalTo(self.viewContainer.snp.centerY).offset(-10)
            make.height.equalTo(25)
        }
        
        labelDetail.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(self.labelPrice.snp.left).offset(-10)
            make.centerY.equalTo(self.viewContainer.snp.centerY).offset(10)
            make.height.equalTo(25)
        }
        
        labelPrice.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(self.labelTitle.snp.centerY)
            make.size.equalTo(CGSize(width: 90, height: 25))
        }
        
        labelUnderPrice.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(self.labelDetail.snp.centerY)
            make.size.equalTo(CGSize(width: 90, height: 25))
        }
    }
    
    // MARK: public
    func setData(iap: IAPModel) {
        iapModel = iap
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = iap.product?.priceLocale
        
        let priceString = formatter.string(from: (iap.product?.price)!)!
        labelTitle.text = iap.product?.localizedTitle
        labelDetail.text = "Subscription " + priceString
        labelPrice.text = iap.pricePerUnit()
        labelUnderPrice.text = iap.unit()
    }
    
    // MARK: events
    @objc private func tapGesture(_ sender:Any) {
        guard let iap = iapModel else { return }
        
        IAPService.shared.purchase(iapItem: iap.product!)
    }
    
}
