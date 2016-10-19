//
//  KeyboardController.swift
//  JCZComposerView
//
//  Created by Juan Cazalla Estrella on 15/4/16.
//  Copyright © 2016 Juan Cazalla Estrella. All rights reserved.
//

import UIKit

class ComposerKeyboardController {
    
    private unowned let composerBottomConstraint: NSLayoutConstraint
    private unowned let viewController: UIViewController
    
    init(composerBottomConstraint: NSLayoutConstraint, viewController: UIViewController) {
        self.composerBottomConstraint = composerBottomConstraint
        self.viewController = viewController
    }
    
    func start() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name:UIKeyboardWillShowNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name:UIKeyboardWillHideNotification,
            object: nil
        )
    }
    
    func stop() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

private extension ComposerKeyboardController {
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let endKeyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue(),
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
                fatalError("Fatal error unwrapping keyboard notification")
        }
        
        let convertedKeyboardFrame = viewController.view.convertRect(endKeyboardFrame, toView: nil)
        setBottomConstraintConstant(convertedKeyboardFrame.size.height - tabBarSize(), duration: duration, curve: curve)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
                fatalError("Fatal error unwrapping keyboard notification")
        }
        
        setBottomConstraintConstant(0, duration: duration, curve: curve)
    }
    
    private func setBottomConstraintConstant(bottomConstraintConstant: CGFloat, duration: Double, curve: UInt) {
        composerBottomConstraint.constant = bottomConstraintConstant
        let animations = {
            self.viewController.view.layoutIfNeeded()
        }
        UIView.animateWithDuration(duration,
                                   delay: 0,
                                   options: UIViewAnimationOptions(rawValue: curve),
                                   animations: animations,
                                   completion: nil)
    }
    
    private func tabBarSize() -> CGFloat {
        var tabBarHeight: CGFloat = 0
        if let tabBar = viewController.tabBarController?.tabBar {
            if !tabBar.hidden {
                tabBarHeight = tabBar.frame.size.height
            }
        }
        
        return tabBarHeight
    }
}
