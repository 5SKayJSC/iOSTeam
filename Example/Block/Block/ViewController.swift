//
//  ViewController.swift
//  Block
//
//  Created by Nguyen Huy on 8/10/17.
//  Copyright © 2017 Nguyen Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("vc1 did load")
    }

    @IBAction func btn1(_ sender: Any) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc2 = sb.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        vc2.text = self.textField.text!
        vc2.textdeliver = {(text) in
            self.textLabel.text = text
        }
//        self.navigationController?.pushViewController(vc2, animated: true)
        self.navigationController?.present(vc2, animated: true, completion: nil);
    }
    override func viewWillAppear(_ animated: Bool) {
        print("vc1 will appear")
    }
    override func viewDidAppear(_ animated: Bool) {
        print("vc1 did appear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("vc1 will disappear")
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("vc1 did disapper")
    }

    
    
    
    
    
    
    @IBAction func btn2(_ sender: Any) {
        let api = API()
        api.getString { (text) in
            self.textLabel.text = text
        }
    }
    
    
    
    @IBAction func btn3(_ sender: Any) {
        let test3 = test()
        test3.getHello(text: "Block") { (data) in
            print(data)
            self.textLabel.text = data
        }
        test3.getHello(text: "Closure") { (data) in
            print(data)
            self.textLabel.text = data
        }

    }
    
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

