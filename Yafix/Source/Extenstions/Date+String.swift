//
//  Date+String.swift
//  Yafix
//
//  Created by Артём Зайцев on 28.07.2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation

extension Date {
    func representation() -> String {
        let dateFormatter = DateFormatter()
        let dateFormat = "MMM dd, EEE"
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self).capitalized
    }
}
