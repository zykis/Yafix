//
//  JRSDKAirportBuilder+Sample.swift
//  Yafix
//
//  Created by Артём Зайцев on 05/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import AviasalesSDK

extension JRSDKAirport {
    static func sample() -> [JRSDKAirport] {
        let builder1 = JRSDKAirportBuilder()
        builder1.iata = "MOW"
        builder1.city = "Moscow"
        builder1.countryName = "Russia"
        
        let builder2 = JRSDKAirportBuilder()
        builder2.iata = "LED"
        builder2.city = "Saint-Petersburg"
        builder2.countryName = "Russia"
        
        return [builder1.build()!, builder2.build()!]
    }
}
