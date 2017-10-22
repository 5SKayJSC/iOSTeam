//
//  HTabbarView.swift
//  testcustomTabbar
//
//  Created by Nguyen Huy on 9/12/17.
//  Copyright © 2017 Nguyen Huy. All rights reserved.
//

import UIKit


let height = UIScreen.main.bounds.size.height
let width = UIScreen.main.bounds.size.width

protocol HTabViewDelegate {
    func indexSelectorTabView(_ indexSelctor: TabbarViewType)
}
class HTabbarView: UIView, HTabItemViewDelegate {
    var delegate: HTabViewDelegate?
    var imageArray: [[UIImage]] = [[#imageLiteral(resourceName: "ic_tab_sync"), #imageLiteral(resourceName: "ic_tab_sync_off") ],
                                   [#imageLiteral(resourceName: "ic_tab_backup_on"),#imageLiteral(resourceName: "ic_tab_backup_off") ],
                                   [#imageLiteral(resourceName: "ic_tab_clean_on"), #imageLiteral(resourceName: "ic_tab_clean_off") ],
                                   [#imageLiteral(resourceName: "ic_tab_setting_on"),#imageLiteral(resourceName: "ic_tab_setting_off") ]]

    let number_item = 4
    var fillColor: UIColor = UIColor.white
    var textArray: [String] = ["One","Two" , "Three" , "Four"]
    var textColorNormal: UIColor = UIColor.darkGray
    var textColorActive: UIColor = UIColor.blue

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear

        let widthItem = self.frame.size.width / CGFloat(number_item)
        let heightItem = self.frame.size.height
        for i in 0..<number_item {
            let htabItem = HTabItemView()
            htabItem.delegate = self
            htabItem.frame = CGRect(x: widthItem * CGFloat(i), y: 0, width: widthItem, height: heightItem)
            htabItem.fillColor = self.fillColor
            htabItem.imageActive = imageArray[i][0]
            htabItem.imageNormal = imageArray[i][1]
            htabItem.text = textArray[i]
            htabItem.textColorActive = self.textColorActive
            htabItem.textColorNormal = self.textColorNormal
            htabItem.index = i
            if i == 0 {
                htabItem.isSelected = true
            }
            self.addSubview(htabItem)
        }
    }

    override var frame: CGRect {
        didSet {
            let widthItem = self.frame.size.width / CGFloat(number_item)
            let heightItem = self.frame.size.height
            var i:Int = 0
            for sub in self.subviews {
                sub.frame = CGRect(x: widthItem * CGFloat(i), y: 0, width: widthItem, height: heightItem)
                i += 1 
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func didSelectHTabItemView(view: HTabItemView) {
        if view.index == TabbarViewType.one.hashValue {
            delegate?.indexSelectorTabView(TabbarViewType.one)
        }
        else if view.index == TabbarViewType.two.hashValue{
            delegate?.indexSelectorTabView(TabbarViewType.two)
        }
        else if view.index == TabbarViewType.three.hashValue{
            delegate?.indexSelectorTabView(TabbarViewType.three)
        }
        else if view.index == TabbarViewType.four.hashValue{
            delegate?.indexSelectorTabView(TabbarViewType.four)
        }
    }

    func resetAllSelectHTabItemView() {
        for sub in self.subviews {
            if let s = sub as? HTabItemView {
                s.isSelected = false
            }
        }

    }
    
    
}
