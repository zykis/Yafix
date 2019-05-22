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
    
    private let dateFormatter = DateFormatter()
    private let dateFormat = "MMM dd, EEE"
    
    init() {
        model = FlightSearchModel(travelSegmentBuilder: JRSDKTravelSegmentBuilder(),
                                  searchInfoBuilder: JRSDKSearchInfoBuilder(),
                                  returnDate: nil)
        model.travelSegmentBuilder.originAirport = AviasalesSDK.sharedInstance().airportsStorage.findAnything(byIATA: "MOW")
        model.travelSegmentBuilder.destinationAirport = AviasalesSDK.sharedInstance().airportsStorage.findAnything(byIATA: "LON")
        model.travelSegmentBuilder.departureDate = Date()
        model.searchInfoBuilder.adults = 1
        model.searchInfoBuilder.travelClass = .economy
        self.update()
    }
    
    mutating func update() {
        dateFormatter.dateFormat = self.dateFormat
        
        departureDate = dateFormatter.string(from: model.travelSegmentBuilder.departureDate ?? Date())
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
        
        var travelClassString: String
        switch model.searchInfoBuilder.travelClass {
        case .economy:
            travelClassString = "Economy"
        case .premiumEconomy:
            travelClassString = "Premium economy"
        case .business:
            travelClassString = "Business"
        case .first:
            travelClassString = "First class"
        @unknown default:
            fatalError()
        }
        travelClass = travelClassString
        
        if let date = model.returnDate {
            returnDate = dateFormatter.string(from: date)
        } else {
            returnDate = "Optional"
        }
    }
}
