//
//  IAPViewController.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/16/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//

import UIKit
import SnapKit

enum IAPThemeType: Int {
    case type1 = 1
    case type2
    case type3
}

class IAPViewController: BaseViewController {
    // MARK: properties
    var type:IAPThemeType = .type2 {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: properties view
    private let collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = UIColor(hex: 0xf1f4f9)
        return view
    }()
    
    // MARK: dealloc
    deinit {
        
    }
    
    // MARK: - Life cycle Viewcontroller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigation()
        initComponent()
        initSubviews()
        initConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - private method
    func initNavigation() {
        title = "In App Purchases"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick(_:)))
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restoreClick(_:)))
    }
    
    func initComponent() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        IAPHeaderView.registerHeaderByClass(collectionView)
        IAPFooterView.registerFooterByClass(collectionView)
        
        IAPCollectionCell_1.registerCellByClass(collectionView)
        IAPCollectionCell_2.registerCellByClass(collectionView)
        IAPCollectionCell_3.registerCellByClass(collectionView)
    }
    
    func initSubviews() {
        self.view.addSubview(collectionView)
    }
    
    func initConstraint() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - public method
    class func createNavigation() -> UINavigationController {
        return UINavigationController(rootViewController: IAPViewController())
    }
    
    // MARK: events
    @objc private func cancelClick(_ sender:Any) {
        if let navi = navigationController {
            if navi.viewControllers.count == 1 {
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func restoreClick(_ sender:Any) {
        IAPService.shared.restore()
    }
    
}

// MARK: UICollectionViewDataSource
extension IAPViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IAPService.shared.productsAvailable.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if type == .type1 {
            let cell = IAPCollectionCell_1.loadCell(collectionView, path: indexPath) as! IAPCollectionCell_1
            cell.setData(iap: IAPService.shared.productsAvailable[indexPath.row])
            return cell
        }
        else if type == .type2 {
            let cell = IAPCollectionCell_2.loadCell(collectionView, path: indexPath) as! IAPCollectionCell_2
            cell.setData(iap: IAPService.shared.productsAvailable[indexPath.row])
            cell.isBestValue = (indexPath.row == IAPService.shared.productsAvailable.count-1)
            return cell
        }
        else {
            let cell = IAPCollectionCell_3.loadCell(collectionView, path: indexPath) as! IAPCollectionCell_3
            cell.setData(iap: IAPService.shared.productsAvailable[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let view = IAPHeaderView.loadHeaderCell(collectionView, path: indexPath) as! IAPHeaderView
            
            return view
        }
        else {
            let view = IAPFooterView.loadFooterCell(collectionView, path: indexPath) as! IAPFooterView
            
            return view
        }
    }
}

// MARK: UICollectionViewDelegate
extension IAPViewController: UICollectionViewDelegate {
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension IAPViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if type == .type2 {
            return CGSize(width: collectionView.bounds.size.width - 40, height: 100)
        }
        return CGSize(width: collectionView.bounds.size.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 110)
    }
}
