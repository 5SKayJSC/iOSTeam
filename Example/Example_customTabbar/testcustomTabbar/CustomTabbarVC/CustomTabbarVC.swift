//
//  CustomTabbarVC.swift
//  testcustomTabbar
//
//  Created by Nguyen Huy on 9/12/17.
//  Copyright © 2017 Nguyen Huy. All rights reserved.
//

import UIKit

let height1: CGFloat = 10
enum TabbarViewType: Int {
    case one = 0
    case two = 1
    case three = 2
    case four = 3
}



class CustomTabbarVC: UITabBarController, HTabViewDelegate {
    let myTabbar: HTabbarView = {
        let view = HTabbarView(frame: CGRect(x: 0, y: (height - 70), width: width, height: 70))

        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let oneVC = OneVC()
        let twoVC = TwoVC()
        let threeVC = ThreeVC()
        let fourVC  = FourVC()

        let oneNavi = UINavigationController.init(rootViewController: oneVC)
        let twoNavi = UINavigationController.init(rootViewController: twoVC)
        let threeNavi = UINavigationController.init(rootViewController: threeVC)
        let fourNavi = UINavigationController.init(rootViewController: fourVC)


        self.viewControllers = [oneNavi, twoNavi, threeNavi,fourNavi]
        self.tabBar.isHidden = true
        self.myTabbar.delegate = self
        self.view.addSubview(self.myTabbar)
    }

    func indexSelectorTabView(_ indexSelctor: TabbarViewType) {
        if indexSelctor == .one {
            self.selectedIndex = TabbarViewType.one.hashValue
        }
        else if indexSelctor == TabbarViewType.two
        {
            self.selectedIndex = TabbarViewType.two.hashValue
        }
        else if indexSelctor == TabbarViewType.three
        {
            self.selectedIndex = TabbarViewType.three.hashValue
        }
        else if indexSelctor == TabbarViewType.four
        {
            self.selectedIndex = TabbarViewType.four.hashValue
        }

    }
    func toAngle(radians: CGFloat) -> CGFloat {
        return CGFloat(radians * 180 / CGFloat.pi)
    }
    
    func toRadians(_ angle: CGFloat) -> CGFloat {
        return angle * CGFloat.pi / 180
    }
}
