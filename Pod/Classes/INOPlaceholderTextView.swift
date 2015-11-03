
import UIKit

public class INOPlaceholderTextView : UITextView {
    
    // MARK: - property
    public var placeholder: String {
        set(text) {
            // 現在のプレースホルダと同じ場合は更新しない
            guard text != _placeholderTextLabel?.text else {
                return
            }
            _placeholderTextLabel?.frame = CGRectMake(
                _placeholderInset.left,
                _placeholderInset.top,
                self.bounds.size.width - _placeholderInset.top - _placeholderInset.left,
                0)
            _placeholderTextLabel?.font = self.font
            _placeholderTextLabel?.text = text
            _placeholderText = text
            _placeholderTextLabel?.sizeToFit()
        }
        get {
            return _placeholderText
        }
    }
    @IBInspectable var _placeholderText: String = ""
    private var _placeholderTextLabel: UILabel?
    private let _placeholderTextColor: UIColor = UIColor.lightGrayColor()
    private let _placeholderInset = UIEdgeInsetsMake(8.0, 5.0, 8.0, 5.0)
    
    // MARK: - init/deinit
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    private func commonInit() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "textChanged:",
            name: UITextViewTextDidChangeNotification, object: nil)
        initPlaceholderTextLabel();
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public override func awakeFromNib() {
        initPlaceholderTextLabel();
    }
    
    // MARK: - private
    /**
    プレースホルダLabelの初期化
    */
    private func initPlaceholderTextLabel() -> Void {
        guard _placeholderTextLabel == nil else {
            return
        }
        let label = UILabel()
        label.frame = CGRectMake(
            _placeholderInset.left,
            _placeholderInset.top,
            self.bounds.size.width - _placeholderInset.top - _placeholderInset.left,
            0)
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.font = self.font
        label.backgroundColor = UIColor.clearColor()
        label.textColor = _placeholderTextColor
        label.alpha = 1
        label.tag = 999
        label.text = _placeholderText
        label.sizeToFit()
        self.addSubview(label)
        self.sendSubviewToBack(label)
        _placeholderTextLabel = label
    }
    
    // MARK: - Notification Observer
    /**
    テキスト編集時
    
    - parameter notification: Notification
    */
    @objc private func textChanged(notification: NSNotification?) -> Void {
        _placeholderTextLabel?.hidden = !self.text.isEmpty
    }
}