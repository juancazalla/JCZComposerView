//
//  ViewController.swift
//  JCZComposerView
//
//  Created by Juan Cazalla Estrella on 15/4/16.
//  Copyright © 2016 Juan Cazalla Estrella. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var keyboardController: ComposerKeyboardController?
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint! {
        didSet {
            keyboardController = ComposerKeyboardController(composerBottomConstraint: bottomConstraint, viewController: self)
        }
    }

    @IBOutlet weak var composerView: ComposerView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardController?.start()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardController?.stop()
    }
}
