//
//  FlightSearchModel.swift
//  Yafix
//
//  Created by Артём Зайцев on 28/04/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation
import AviasalesSDK

struct FlightSearchViewModel {
    var model: FlightSearchModel
    
    var departureDate: String = ""
    var originAirportIATA: String = ""
    var originAirportDescription: String = ""
    
    var destinationAirportIATA: String = ""
    var destinationAirportDescription: String = ""
    
    var passengers: String = ""
    
    var travelClass: String = ""
    
    var returnDate: String = ""
    
    init() {
        model = FlightSearchModel(travelSegmentBuilder: JRSDKTravelSegmentBuilder(),
                                  searchInfoBuilder: JRSDKSearchInfoBuilder(),
                                  returnDate: nil)
        model.travelSegmentBuilder.originAirport = AviasalesSDK.sharedInstance().airportsStorage.findAnything(byIATA: "MOW")
        model.travelSegmentBuilder.destinationAirport = AviasalesSDK.sharedInstance().airportsStorage.findAnything(byIATA: "LON")
        // FIXME: adding time interval from GMT. May be fixed with setting up Calendar locale?
        model.travelSegmentBuilder.departureDate = Date().addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
        model.searchInfoBuilder.adults = 1
        model.searchInfoBuilder.travelClass = .economy
        self.update()
    }
    
    mutating func update() {
        departureDate = model.travelSegmentBuilder.departureDate!.representation()
        originAirportIATA = model.travelSegmentBuilder.originAirport?.iata ?? ""
        originAirportDescription = "\(model.travelSegmentBuilder.originAirport?.city?.appending(", ") ?? "")\(model.travelSegmentBuilder.originAirport?.countryName ?? "")"
        
        destinationAirportIATA = model.travelSegmentBuilder.destinationAirport?.iata ?? ""
        destinationAirportDescription = "\(model.travelSegmentBuilder.destinationAirport?.city?.appending(", ") ?? "")\(model.travelSegmentBuilder.destinationAirport?.countryName ?? "")"
        
        passengers = ""
        if model.searchInfoBuilder.adults != 0 {
            passengers += "\(model.searchInfoBuilder.adults) adults"
        }
        if model.searchInfoBuilder.children != 0 {
            if !passengers.isEmpty {
                passengers += ", "
            }
            passengers += "\(model.searchInfoBuilder.children) children"
        }
        if model.searchInfoBuilder.infants != 0 {
            if !passengers.isEmpty {
                passengers += ", "
            }
            passengers += "\(model.searchInfoBuilder.infants) infants"
        }
        
        travelClass = travelClassRepresentation(travelClass: model.searchInfoBuilder.travelClass)
        
        if let date = model.returnDate {
            returnDate = date.representation()
        } else {
            returnDate = "Optional"
        }
    }
}
