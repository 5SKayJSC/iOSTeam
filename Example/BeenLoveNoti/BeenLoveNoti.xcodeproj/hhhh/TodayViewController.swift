//
//  TodayViewController.swift
//  hhhh
//
//  Created by Nguyen Huy on 10/26/17.
//  Copyright © 2017 Nguyen Huy. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding {
    var time: Timer?
    var i: Int = 9;

    let userDefaults = UserDefaults(suiteName: "group.5skay.beenLove")
    let label: UILabel = {
        let label = UILabel()
        //label.text = "I love u"
        label.textColor = UIColor.red
        label.textAlignment = .center
        return label
    }()

    let countLoveDay: UILabel = {
        let label = UILabel()
        label.text = "loading"
        label.textColor = UIColor.red
        label.textAlignment = .center
        return label
    }()

    let image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "boy.png")
        image.contentMode = .scaleAspectFit
        return image
    }()

    let heart: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "heart.png")
        image.contentMode = .scaleAspectFit
        return image
    }()
    let girl: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "girl.png")
        image.contentMode = .scaleAspectFit
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateData()
    }

    func updateData() {
        APILoveDays.getLoveDays { (lovedays) in
            self.countLoveDay.text = lovedays

        }


    }

    func changeCount(noti: Notification) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        label.frame = CGRect(x: 67, y: 0, width: 80, height: 35)

        let h = self.view.bounds.size.height
        let w = self.view.bounds.size.width
        image.frame = CGRect(x: (w / 12), y: (5), width: 100, height: 100)
        heart.frame = CGRect(x: (w / 2 - 27), y: (h / 8 + 22), width: 60, height: 60)
        girl.frame = CGRect(x: (w / 4 * 3 - 10), y: (5), width: 100, height: 100)

        self.countLoveDay.frame = CGRect(x: w / 2 - 40, y: 10, width: 100, height: 22)

        self.view.addSubview(self.label)
        self.view.addSubview(self.image)
        self.view.addSubview(self.heart)
        self.view.addSubview(self.girl)
        self.view.addSubview(self.countLoveDay)

    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {


        
        completionHandler(NCUpdateResult.newData)
    }
    
}
