//
//  GrowingTextView.swift
//  JCZComposerView
//
//  Created by Juan Cazalla Estrella on 15/4/16.
//  Copyright © 2016 Juan Cazalla Estrella. All rights reserved.
//

import UIKit

class GrowingTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let textViewFont = font else {
            fatalError("growingTextView.font can't be nil")
        }
        
        let maxHeight: CGFloat = ceil(textViewFont.lineHeight * CGFloat(ComposerStyle.maxLines))
        let heightThatFits = sizeThatFits(CGSize(width: frame.width, height: CGFloat.max)).height
        if heightThatFits != frame.height && (scrollEnabled != (heightThatFits >= maxHeight)) {
            scrollEnabled = heightThatFits >= maxHeight
            scrollRangeToVisible(selectedRange)
            setNeedsUpdateConstraints()
        }
    }
}

private extension GrowingTextView {
    func setup() {
        textContainerInset = UIEdgeInsets(top: 4.0, left: 2.0, bottom: 4.0, right: 2.0)
        contentInset = UIEdgeInsets(top: 1.0, left: 0.0, bottom: 1.0, right: 0.0)
        let cornerRadius: CGFloat = 6.0
        backgroundColor = UIColor.whiteColor()
        layer.borderWidth = 0.5
        layer.borderColor = ComposerStyle.borderColor.CGColor
        layer.cornerRadius = cornerRadius
        scrollIndicatorInsets = UIEdgeInsets(top: cornerRadius, left: 0.0, bottom: cornerRadius, right: 0.0)
        scrollEnabled = false
        font = ComposerStyle.textViewFont
    }
}
