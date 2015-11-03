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
    @IBOutlet weak var _tableView: UITableView!

    @IBOutlet weak var _textBox: INOMessageTextBox!
    @IBOutlet weak var _bottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        _textBox.rightButtonTouchEvent = { (textBox: INOMessageTextBox, text: String) -> Void in
            print(text)
        }
        _textBox.contentSizeDidChangeEvent = { (textBox: INOMessageTextBox, differenceWidth: CGFloat, differenceHeight: CGFloat) -> Void in
            print("diff width: ", differenceWidth,"height: ", differenceHeight)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) -> Void {
        let rect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration:NSTimeInterval = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        self._bottomConstraint?.constant = rect.height
        UIView.animateWithDuration(duration) {
            self._textBox.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) -> Void {
        let rect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration:NSTimeInterval = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        self._bottomConstraint?.constant = rect.height
        UIView.animateWithDuration(duration) {
            self._textBox.layoutIfNeeded()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell?.textLabel?.text = String(indexPath.row)
        return cell!
    }
}

extension UIView {
    internal func constraint(firstItem firstItem: NSObject, firstAttribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        let items = self.constraints.filter {
            $0.firstItem as! NSObject === firstItem && $0.firstAttribute == firstAttribute
        }
        return items.count > 0 ? items.first : nil
    }
}

