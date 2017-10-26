//
//  ViewController2.swift
//  delegate
//
//  Created by Nguyen Huy on 8/10/17.
//  Copyright © 2017 Nguyen Huy. All rights reserved.
//

import UIKit

protocol TextDelived: class {
    func protocolText(_ text: String)
}


class ViewController2: UIViewController {
    weak var delegate: TextDelived?

    var textRecive: String = ""
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var textFileld2: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = textRecive
        // Do any additional setup after loading the view.
        self.title = "VC2"
    }
    @IBAction func btn2(_ sender: Any) {
        if let text = textFileld2.text{
            delegate?.protocolText(text)
        }
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
