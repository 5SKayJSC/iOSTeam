//
//  ViewController.swift
//  huyyyy
//
//  Created by Nguyen Huy on 10/26/17.
//  Copyright © 2017 Nguyen Huy. All rights reserved.
//

import UIKit

let userDefaults = UserDefaults(suiteName: "group.5skay.beenLove")

class ViewController: UIViewController {

    @IBOutlet weak var labelInput: UITextField!

    @IBOutlet weak var countLabel: UILabel!



    override func viewDidLoad() {
        super.viewDidLoad()
        
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APILoveDays.getLoveDays { (loveDays) in
            self.countLabel.text = loveDays
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

