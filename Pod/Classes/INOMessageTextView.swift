import UIKit

public class INOMessageTextView: INOPlaceholderTextView {
    private let kDefaultFontSize: CGFloat = 12.0
    private let kDefaultMaxLines: UInt = 10
    
    // MARK: - init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    
    // MARK: - internal
    /**
     初期化時のtextViewの高さを取得
     
     - returns: TextView Height
     */
    internal func initHeight() -> CGFloat {
        guard let font = self.font else {
            return 0
        }
        return font.lineHeight + self.textContainerInset.top + self.textContainerInset.bottom
    }
    
    /**
     現在のTextViewの高さを取得
     
     - returns: TextViewHeight
     */
    internal func currentHeight() -> CGFloat {
        if numberOfLines() > kDefaultMaxLines { // 最大行数を超える場合
            var lineHeight: CGFloat = 0
            if let font = self.font {
                lineHeight = font.lineHeight
            }
            return (lineHeight * CGFloat(kDefaultMaxLines)) + self.textContainerInset.top + self.textContainerInset.bottom
        } else {
            return self.sizeThatFits(self.frame.size).height
        }
    }
    
    /**
     現在の行数を取得
     
     - returns: 行数
     */
    internal func numberOfLines() -> UInt {
        var contentSize: CGSize = self.contentSize
        var contentHeight: CGFloat = contentSize.height
        contentHeight -= self.textContainerInset.top + self.textContainerInset.bottom
        var lines: UInt = UInt(fabs(contentHeight / (self.font?.lineHeight)!))
        if lines == 1 && contentSize.height > self.bounds.size.height {
            contentSize.height = self.bounds.size.height;
            self.contentSize = contentSize;
        }
        if (lines == 0) {
            lines = 1;
        }
        return lines
    }
    
    // MARK: - private
    /**
    共通初期化処理
    */
    private func commonInit() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.cornerRadius = 3
        self.font = UIFont.systemFontOfSize(kDefaultFontSize)
    }
}
