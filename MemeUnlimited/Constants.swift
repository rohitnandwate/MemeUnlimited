//
//  Constants.swift
//  MemeUnlimited
//
//  Created by Nandwate, Rohit on 3/5/17.
//  Copyright © 2017 Nandwate, Rohit. All rights reserved.
//

import Foundation
import UIKit

struct StringConstants {
    static let ALERT_CLEAR_MEME_TITLE = "Clear Current Meme"
    static let ALERT_CLEAR_MEME_MSG = "Clear the meme editor?"
    static let ALERT_CANCEL_BUTTON = "Cancel"
    static let ALERT_CLEAR_BUTTON = "Clear"

    static let ALERT_SAVE_MEME_TITLE = "Save Meme"
    static let ALERT_SAVE_MEME_MSG = "Save current version for later?"
    static let ALERT_SAVE_BUTTON = "Save"
    
    static let MEME_EDITOR_TOP_TEXT = "TOP"
    static let MEME_EDITOR_BOTTOM_TEXT = "BOTTOM"
    static let EMPTY_TEXT = ""
}

struct Constants {
    static let TOOLBAR_ALPHA: CGFloat = 0.75
    static let HIDE_TOOLBAR_ALPHA: CGFloat = 0.0
    
    static let FRAME_ORIGIN: CGFloat = 0
}

struct SegueIds {
    static let SAVED_MEME = "savedMemeSegue"
}

struct Attributes {
    static let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0]
}


