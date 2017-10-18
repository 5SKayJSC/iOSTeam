//
//  BaseCollectionCell.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
    // MARK: init
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: deinit
    deinit {
        BLogInfo("")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: define for cell
    class func identifier() -> String {
        return String(describing: self.self)
    }
    
    class func size() -> CGSize {
        return CGSize.zero
    }
    
    class func registerCellByClass(_ collectionView: UICollectionView) {
        collectionView.register(self.self, forCellWithReuseIdentifier: self.identifier())
    }
    
    class func registerCellByNib(_ collectionView: UICollectionView) {
        let nib = UINib(nibName: self.identifier(), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: self.identifier())
    }
    
    class func loadCell(_ collectionView: UICollectionView, path: IndexPath) -> BaseCollectionCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier(), for: path) as! BaseCollectionCell
    }
    
}
