//
//  Localizable.swift
//  Yafix
//
//  Created by Артём Зайцев on 02.08.2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation
import UIKit


protocol Localizable {
    var localized: String { get }
}


extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}


protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}


extension UILabel: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
}


extension UIButton: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}
