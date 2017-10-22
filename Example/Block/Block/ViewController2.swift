//
//  ViewController2.swift
//  Block
//
//  Created by Nguyen Huy on 8/10/17.
//  Copyright © 2017 Nguyen Huy. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var textlabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var text: String = ""
    
    var textdeliver: ((_ text: String) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("vc2 did load")
        self.textlabel.text = text
    }

    @IBAction func btnchuyendulieu(_ sender: Any) {
        if let handler = self.textdeliver{
            handler(textField.text!)
        }
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true , completion: nil);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("vc2 will appear")
    }
    override func viewDidAppear(_ animated: Bool) {
        print("vc2 did appear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("vc2 will disappear")
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("vc2 did disapper")
    }
}
