//
//  File.swift
//  INOMessageTextView
//
//  Created by akira morooka on 2015/10/28.
//  Copyright © 2015年 CocoaPods. All rights reserved.
//

import UIKit

/**
右ボタン押下時
 
 - parameter textBox: INOMessageTextBox
 - parameter text:    TextViewに入力中テキスト
 */
public typealias TouchRightButtonEvent = (textBox: INOMessageTextBox, text: String) -> Void
public typealias TextBoxContentSizeDidChangeEvent = (textBox: INOMessageTextBox, differenceWidth: CGFloat, differenceHeight: CGFloat) -> Void

public class INOMessageTextBox : UIView, UITextViewDelegate {
    public var rightButtonTouchEvent: TouchRightButtonEvent? {
        set(event) {
            _rightButtonTouchEvent = event
        }
        get {
            return _rightButtonTouchEvent
        }
    }
    public var contentSizeDidChangeEvent: TextBoxContentSizeDidChangeEvent? {
        set(event) {
            _contentSizeDidChangeEvent = event
        }
        get {
            return _contentSizeDidChangeEvent
        }
    }
    internal var _contentSizeDidChangeEvent: TextBoxContentSizeDidChangeEvent?
    internal var _rightButtonTouchEvent: TouchRightButtonEvent?
    internal var _heightConstraint: NSLayoutConstraint?
    internal var _rightButtonWidthC: NSLayoutConstraint?
    internal var _rightButtonRightMarginC: NSLayoutConstraint?
    internal var _rightButton: UIButton!
    internal var _rightButtonSize: CGSize!
    internal var _textView: INOMessageTextView!
    private var _textBoxInset = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)
    private var _boxBounds = CGRectZero
    
    // MARK: - init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initHeightConstraint()
        initSubviews()
        // 初期表示は、1行分の高さ固定
        _heightConstraint?.constant = _textView.initHeight() + (_textBoxInset.top + _textBoxInset.bottom)
        self.addObserver(self, forKeyPath: NSStringFromSelector("bounds"), options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    deinit {
        _rightButtonTouchEvent = nil
        self.removeObserver(self, forKeyPath: NSStringFromSelector("bounds"))
    }
  
    // MARK: - Private
    /**
     Viewの高さに制約を設定する
     
     */
    private func initHeightConstraint() -> Void {
        // 現在設定されている制約に高さ制約があればセット
        for const : NSLayoutConstraint in self.constraints {
            if const.firstAttribute == NSLayoutAttribute.Height {
                _heightConstraint = const
                break
            }
        }
        // なにもセットされていなければ、高さ制約を生成
        if _heightConstraint == nil {
            let height =  NSLayoutConstraint(item: self,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.Height,
                multiplier: 1.0,
                constant: 0)
            self.addConstraint(height)
            _heightConstraint = height
        }
    }
   
    /**
     Subviewの初期化
     */
    private func initSubviews() ->Void {
        /* add subviews */
        let textView = INOMessageTextView(frame: CGRectMake(0, 0, self.frame.width, self.frame.width))
        textView.delegate = self
        self.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        _textView = textView
        
        let button = UIButton(type: UIButtonType.System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        button.setTitle("Send", forState: UIControlState.Normal)
        button.addTarget(self, action: "touchRightButton:", forControlEvents: UIControlEvents.TouchUpInside)
        _rightButtonSize = button.sizeThatFits(button.frame.size)
        self.addSubview(button)
        _rightButton = button
        
        /* set autolayout */
        let views = ["textView" : _textView, "rightButton" : button]
        let matrics = [
            "top" : _textBoxInset.top,
            "right" : _textBoxInset.right,
            "bottom": _textBoxInset.bottom,
            "left" : _textBoxInset.left,
            "button_height" : _rightButtonSize.height
        ]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(left)-[textView]-(right)-[rightButton(0)]-(0)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: matrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(top)-[textView]-(bottom)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: matrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=0)-[rightButton(button_height)]-(bottom)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: matrics, views: views))
        
        _rightButtonWidthC = constraint(firstItem: button, firstAttribute: NSLayoutAttribute.Width)
        _rightButtonRightMarginC = constraint(firstItem: self, firstAttribute: NSLayoutAttribute.Trailing)
        
    }
    
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object === self && keyPath == NSStringFromSelector("bounds") {
            if !CGRectEqualToRect(_boxBounds, CGRectZero) {
                self._contentSizeDidChangeEvent?(
                    textBox: self,
                    differenceWidth: self.bounds.width - _boxBounds.width,
                    differenceHeight: self.bounds.height - _boxBounds.height)
            }
            _boxBounds = self.bounds
        }
    }
    
    // MARK: - internal
    internal func touchRightButton(sender: UIButton) -> Void {
        _rightButtonTouchEvent?(textBox: self, text: _textView.text)
    }
    
    // MARK: - UITextViewDelegate
    public func textViewDidChange(textView: UITextView) {
        _textView.flashScrollIndicators()
        
        self._heightConstraint?.constant = self._textView.currentHeight() + (_textBoxInset.top + _textBoxInset.bottom)
        self.setNeedsUpdateConstraints()
        self._textView.setNeedsUpdateConstraints()
        
        if textView.text.characters.count > 0 {
            _rightButtonRightMarginC?.constant = _textBoxInset.right
            _rightButtonWidthC?.constant = _rightButtonSize.width
            self._textView.setNeedsUpdateConstraints()
        } else {
            _rightButtonRightMarginC?.constant = 0
            _rightButtonWidthC?.constant = 0
        }
        
        UIView.animateWithDuration(0.35) {
            self._textView.layoutIfNeeded()
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
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