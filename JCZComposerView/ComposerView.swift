//
//  ComposerView.swift
//  JCZComposerView
//
//  Created by Juan Cazalla Estrella on 15/4/16.
//  Copyright © 2016 Juan Cazalla Estrella. All rights reserved.
//

import UIKit
import OAStackView

protocol ComposerViewDelegate {
    func rightButtonDidClicked(sender: UIButton)
}

class ComposerView: UIView {
    
    var growingTextView: GrowingTextView!
    var delegate: ComposerViewDelegate?
    var text: String {
        return growingTextView.text
    }
    var enabled: Bool {
        didSet {
            rightButton.enabled = growingTextView.text.characters.count > 0 && enabled
            growingTextView.userInteractionEnabled = enabled
        }
    }
    
    private var rightButton: UIButton
    private var composerStackView: OAStackView!
    private var rightContainerView: UIView!
    private var upperBorderView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        rightButton = ComposerView.createRightButton()
        enabled = true
        
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func resignFirstResponder() -> Bool {
        return self.growingTextView.resignFirstResponder()
    }
}

private extension ComposerView {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = ComposerStyle.backgroundColor
        
        setupRightView()
        setupGrowingTextView()
        setupComposerStackView()
        setupUpperBorderView()
        
        setupConstraints()
    }
    
    func setupRightView() {
        rightButton.addTarget(self, action: #selector(rightButtonDidClicked), forControlEvents: .TouchUpInside)
        rightContainerView = UIView()
        rightContainerView.addSubview(rightButton)
        rightContainerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupGrowingTextView() {
        growingTextView = GrowingTextView(frame: CGRect.zero)
        growingTextView.setContentCompressionResistancePriority(250, forAxis: .Horizontal)
        growingTextView.delegate = self
    }
    
    func setupComposerStackView() {
        composerStackView = OAStackView(arrangedSubviews: [growingTextView, rightContainerView])
        composerStackView.translatesAutoresizingMaskIntoConstraints = false
        composerStackView.alignment = OAStackViewAlignment.Bottom
        composerStackView.distribution = OAStackViewDistribution.Fill
        composerStackView.axis = .Horizontal
        composerStackView.spacing = ComposerStyle.spacing
        addSubview(composerStackView)
    }
    
    func setupUpperBorderView() {
        upperBorderView = UIView()
        upperBorderView.backgroundColor = ComposerStyle.borderColor
        upperBorderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(upperBorderView)
    }
    
    func setupConstraints() {
        ComposerView.setRightButtonConstraints(rightButton)
        ComposerView.setGrowingTextViewConstraints(growingTextView)
        ComposerView.setUpperBorderConstraints(upperBorderView)
        ComposerView.setContainerStackViewConstraints(composerStackView, upperBorderView: upperBorderView)
    }
    
    @objc func rightButtonDidClicked(sender: UIButton) {
        delegate?.rightButtonDidClicked(sender)
    }
}

private extension ComposerView {
    static func createRightButton() -> UIButton {
        let rightButton = UIButton(type: .System)
        rightButton.setTitle(ComposerStyle.rightButtonText, forState: .Normal)
        rightButton.titleLabel?.font = ComposerStyle.rightButtonFont
        rightButton.setTitleColor(ComposerStyle.rightButtonColor, forState: .Normal)
        rightButton.setTitleColor(ComposerStyle.rightButtonColor.colorWithAlphaComponent(0.5), forState: .Disabled)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.setContentHuggingPriority(500, forAxis: .Horizontal)
        rightButton.enabled = false
        
        return rightButton
    }
    
    static func setRightButtonConstraints(button: UIButton) {
        let views = ["button": button]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[button]-0-|",
            options: [],
            metrics: nil,
            views: views
        )
        let verticalContraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-0-[button(\(ComposerStyle.rightButtonHeight))]-0-|",
            options: [],
            metrics: nil,
            views: views
        )
        button.superview?.addConstraints(horizontalConstraints)
        button.superview?.addConstraints(verticalContraints)
    }
    
    static func setGrowingTextViewConstraints(growingTextView: GrowingTextView) {
        guard let textViewFont = growingTextView.font else {
            fatalError("growingTextView.font can't be nil")
        }
        
        let views = ["growingTextView": growingTextView]
        let maxHeight = ceil(textViewFont.lineHeight * CGFloat(ComposerStyle.maxLines))
        let verticalContraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[growingTextView(<=\(maxHeight))]|",
            options: [],
            metrics: nil,
            views: views
        )
        
        growingTextView.superview?.addConstraints(verticalContraints)
    }
    
    static func setUpperBorderConstraints(upperBorderView: UIView) {
        let views = ["upperBorderView": upperBorderView]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[upperBorderView]-0-|",
            options: [],
            metrics: nil,
            views: views
        )
        let onePixelConstant = 1.0 / UIScreen.mainScreen().scale
        let verticalContraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-0-[upperBorderView(\(onePixelConstant))]",
            options: [],
            metrics: nil,
            views: views
        )
        let constraints = horizontalConstraints + verticalContraints
        upperBorderView.superview?.addConstraints(constraints)
    }
    
    static func setContainerStackViewConstraints(containerStackView: OAStackView, upperBorderView: UIView) {
        let views = ["containerStackView": containerStackView, "upperBorderView": upperBorderView]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-\(ComposerStyle.padding.left)-[containerStackView]-\(ComposerStyle.padding.right)-|",
            options: [],
            metrics: nil,
            views: views
        )
        let verticalContraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[upperBorderView]-\(ComposerStyle.padding.top)-[containerStackView]-\(ComposerStyle.padding.bottom)-|",
            options: [],
            metrics: nil,
            views: views
        )
        let constraints = horizontalConstraints + verticalContraints
        containerStackView.superview?.addConstraints(constraints)
    }
}

extension ComposerView: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        rightButton.enabled = textView.text.characters.count > 0
    }
}
