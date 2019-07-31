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
        return "Economy"
    case .premiumEconomy:
        return "Premium economy"
    case .business:
        return "Business"
    case .first:
        return "First class"
    @unknown default:
        fatalError("Unknown travel class")
    }
}
