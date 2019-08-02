//
//  JRSDKPrice+UserCurrency.swift
//  Yafix
//
//  Created by Артём Зайцев on 02.08.2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation
import AviasalesSDK

extension JRSDKPrice {
    
    @objc func formattedPriceinUserCurrency() -> String {
        let price = AviasalesNumberUtil.formatPrice(priceInUserCurrency()) ?? ""
        return price
    }
}
