//
//  Utils.swift
//  Yafix
//
//  Created by Артём Зайцев on 31.07.2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation
import AviasalesSDK

func travelClassRepresentation(travelClass: JRSDKTravelClass) -> String {
    switch travelClass {
    case .economy:
        return NSLocalizedString("economy", comment: "")
    case .premiumEconomy:
        return NSLocalizedString("premium_economy", comment: "")
    case .business:
        return NSLocalizedString("business", comment: "")
    case .first:
        return NSLocalizedString("first_class", comment: "")
    @unknown default:
        fatalError("Unknown travel class")
    }
}
