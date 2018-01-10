//
//  ViewController.swift
//  userDeafultsTest
//
//  Created by Tony Cioara on 1/10/18.
//  Copyright © 2018 Tony Cioara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let value = UserDefaults.standard.string(forKey: "messageTF")
        if value != nil {
            messageTF.text = value
            messageLabel.text = value
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SaveButton(_ sender: Any) {
        UserDefaults.standard.set(messageTF.text, forKey: "messageTF")
    }
    
}

