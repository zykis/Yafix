//
//  UIViewController+dismiss.swift
//  Yafix
//
//  Created by Артём Зайцев on 06/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

extension UIViewController {
    @objc func dismissAnimated() {
        self.dismiss(animated: true, completion: nil)
    }
}
