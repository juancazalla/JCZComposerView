//
//  ComposerStyle.swift
//  JCZComposerView
//
//  Created by Juan Cazalla Estrella on 15/4/16.
//  Copyright © 2016 Juan Cazalla Estrella. All rights reserved.
//

import UIKit

struct ComposerStyle {
    
    // Sizes
    static let padding = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
    static let spacing: CGFloat = 10
    static let maxLines = 5
    static let rightButtonHeight = 28
    
    // Colors
    static let textViewFontColor = UIColor.blackColor()
    static var rightButtonColor = UIColor(red: 34/255.0, green: 167/255.0, blue: 240/255.0, alpha: 1)
    static var backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 0.7)
    static var borderColor = UIColor.lightGrayColor()
    
    // Fonts
    static var textViewFont = UIFont.systemFontOfSize(17)
    static var rightButtonFont = UIFont.boldSystemFontOfSize(16)
    
    static let rightButtonText = "Send"
}
