//
//  FlightSearchModel.swift
//  Yafix
//
//  Created by Артём Зайцев on 06/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation
import AviasalesSDK

struct FlightSearchModel {
    let travelSegmentBuilder: JRSDKTravelSegmentBuilder
    let searchInfoBuilder: JRSDKSearchInfoBuilder
    let returnDate: Date? = nil
}
