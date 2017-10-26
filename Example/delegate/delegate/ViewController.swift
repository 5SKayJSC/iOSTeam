//
//  ViewController.swift
//  delegate
//
//  Created by Nguyen Huy on 8/10/17.
//  Copyright © 2017 Nguyen Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TextDelived, ChangeText {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "VC1"
    }

    @IBOutlet weak var btn: UIButton!
    
    
    @IBAction func click(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc2 = sb.instantiateViewController(withIdentifier: "ViewController2" ) as! ViewController2
        vc2.delegate = self

        if let text = self.textField.text {
            vc2.textRecive = text
            //vc2.textLabel.text = text
        }
        self.navigationController?.pushViewController(vc2, animated: true)
    }
    func protocolText(_ text: String) {
        textLabel.text = text
    }
    @IBAction func clicktest2(_ sender: Any) {
        let api = API()
        api.delegate = self
        api.count()
    }
    func protocolChangeText(string: String) {
        textLabel.text = string
        print(string)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

