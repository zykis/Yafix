//
//  AiroirtPickerCellViewModel.swift
//  Yafix
//
//  Created by Артём Зайцев on 04/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation
import AviasalesSDK

struct AirportPickerCellViewModel {
    let model: JRSDKAirport
    
    let iata: String
    let city: String
    let country: String
    var description: String {
        return "\(self.city), \(self.country)"
    }
    
    init(airport: JRSDKAirport) {
        self.model = airport
        self.iata = airport.iata
        self.city = airport.city ?? "City"
        self.country = airport.countryName ?? "Country"
    }
}
