//
//  BaseReusableCollectionView.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/17/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import UIKit

class BaseReusableCollectionView: UICollectionReusableView {
    // MARK: init
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: define for cell
    static func identifier() -> String {
        return String(describing: self.self)
    }
    
    static func size() -> CGSize {
        return CGSize.zero
    }
    
    // MARK: header
    static func registerHeaderByClass(_ collectionView: UICollectionView) {
        collectionView.register(self.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.identifier())
    }
    
    static func registerHeaderByNib(_ collectionView: UICollectionView) {
        let nib = UINib(nibName: self.identifier(), bundle: nil)
        collectionView.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.identifier())
    }
    
    static func loadHeaderCell(_ collectionView: UICollectionView, path: IndexPath) -> BaseReusableCollectionView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: self.identifier(), for: path) as! BaseReusableCollectionView
    }
    
    // MARK: footer
    static func registerFooterByClass(_ collectionView: UICollectionView) {
        collectionView.register(self.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.identifier())
    }
    
    static func registerFooterByNib(_ collectionView: UICollectionView) {
        let nib = UINib(nibName: self.identifier(), bundle: nil)
        collectionView.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.identifier())
    }
    
    static func loadFooterCell(_ collectionView: UICollectionView, path: IndexPath) -> BaseReusableCollectionView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.identifier(), for: path) as! BaseReusableCollectionView
    }
    
}
