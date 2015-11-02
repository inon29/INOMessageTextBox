//
//  ViewController.swift
//  INOMessageTextBox
//
//  Created by Your Name Heiya on 11/02/2015.
//  Copyright (c) 2015 Your Name Heiya. All rights reserved.
//

import UIKit
import INOMessageTextBox

class ViewController: UIViewController {

    @IBOutlet weak var _textBox: INOMessageTextBox!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        _textBox.rightButtonTouchEvent = { (textBox: INOMessageTextBox, text: String) -> Void in
            print(text)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

