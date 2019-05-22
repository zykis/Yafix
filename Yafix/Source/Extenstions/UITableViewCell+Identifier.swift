//
//  UITableViewCell+Identifier.swift
//  Yafix
//
//  Created by Артём Зайцев on 04/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
