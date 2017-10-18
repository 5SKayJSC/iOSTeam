//
//  IAPCollectionCell_1.swift
//  OneTranslate
//
//  Created by Quynh Nguyen on 10/17/17.
//  Copyright © 2017 Quynh Nguyen. All rights reserved.
//

import UIKit
import StoreKit

class IAPCollectionCell_1: BaseCollectionCell {
    private var iapModel: IAPModel?
    
    // MARK: properties view
    private let viewFrameBorder:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor(hex: 0xc2c2c2).cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let viewContainer:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let imgViewPrice:UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "bg_priceblue"))
        return view
    }()
    
    private let labelPrice:UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 15)
        view.textAlignment = .center
        view.numberOfLines = 1
        view.textColor = UIColor.white
        return view
    }()
    
    private let labelTitle:UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 16)
        view.textAlignment = .left
        view.numberOfLines = 1
        return view
    }()
    
    private let labelDetail:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private let btnBuy:UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Buy now", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.setTitleColor(UIColor(hex: 0x67bbff), for: .highlighted)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        view.clipsToBounds = true
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
        self.backgroundColor = UIColor.white
        btnBuy.addTarget(self, action: #selector(buyClick(_:)), for: .touchUpInside)
    }
    
    private func initSubviews() {
        self.contentView.addSubview(viewFrameBorder)
        self.contentView.addSubview(viewContainer)
        viewContainer.addSubview(imgViewPrice)
        viewContainer.addSubview(labelPrice)
        viewContainer.addSubview(labelTitle)
        viewContainer.addSubview(labelDetail)
        viewContainer.addSubview(btnBuy)
    }
    
    private func initConstraint() {
        viewFrameBorder.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsetsMake(5, 20, 5, 20))
        }
        
        viewContainer.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsetsMake(5, 20, 5, 20))
        }
        
        let x:CGFloat = -3
        let top:CGFloat = 3
        imgViewPrice.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(x)
            make.top.equalToSuperview().offset(top)
            make.size.equalTo(CGSize(width: 63, height: 35))
        }
        
        labelPrice.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(x)
            make.top.equalToSuperview().offset(top)
            make.size.equalTo(CGSize(width: 63, height: 35))
        }
        
        labelTitle.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgViewPrice.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(top)
            make.height.equalTo(35)
        }
        
        // text auto scale height
        labelDetail.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(self.labelPrice.snp.bottom).offset(5)
            make.bottom.equalTo(self.btnBuy.snp.top).offset(-5)
        }
        
        btnBuy.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.viewContainer.snp.centerX)
            make.bottom.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 80, height: 25))
        }
    }
    
    // MARK: public
    func setData(iap: IAPModel) {
        iapModel = iap
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = iap.product?.priceLocale
        
        labelPrice.text = formatter.string(from: (iap.product?.price)!)
        labelTitle.text = iap.product?.localizedTitle
        labelDetail.text = iap.product?.localizedDescription
    }
    
    // MARK: events
    @objc private func buyClick(_ sender:Any) {
        guard let iap = iapModel else { return }
        
        IAPService.shared.purchase(iapItem: iap.product!)
    }
}
