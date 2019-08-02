//
//  SearchResultsViewModel.swift
//  Yafix
//
//  Created by Артём Зайцев on 08/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation
import AviasalesSDK

struct TicketViewModel {
    let model: JRSDKTicket
    
    let airline: String
    let airlineIcon: String
    let price: String
    let departureTime: String
    let arrivalTime: String
    let flightDuration: String
    let originIATA: String
    let destinationIATA: String
    
    init(model: JRSDKTicket) {
        self.model = model
        
        let proposal = model.proposals.firstObject as! JRSDKProposal
        let directFlightSegment = model.flightSegments.firstObject as! JRSDKFlightSegment
        let flight = directFlightSegment.flights.firstObject as! JRSDKFlight
        
        self.airline = model.mainAirline.name
        self.airlineIcon = ""
        
//        self.price = "₽ " + TicketViewModel.priceWithDots(price: proposal.price.priceInRUB())
        self.price = proposal.price.formattedPriceinUserCurrency()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale.current
        let departureDate = Date(timeIntervalSince1970: directFlightSegment.departureDateTimestamp.doubleValue)
        let arrivalDate = Date(timeIntervalSince1970: directFlightSegment.arrivalDateTimestamp.doubleValue)
        
        self.departureTime = dateFormatter.string(from: departureDate)
        self.arrivalTime = dateFormatter.string(from: arrivalDate)
        
        self.originIATA = flight.originAirport.iata
        self.destinationIATA = flight.destinationAirport.iata
        
        let hours = Int(directFlightSegment.totalDurationInMinutes / 60)
        let minutes = directFlightSegment.totalDurationInMinutes % 60
        self.flightDuration = "\(hours)\(NSLocalizedString("hours_abbreviation", comment: "")) \(minutes)\(NSLocalizedString("minutes_abbreviation", comment: ""))"
    }
    
    private static func priceWithDots(price: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(integerLiteral: price.intValue))!
    }
    
    var modelProposal: JRSDKProposal {
        return self.model.proposals.firstObject as! JRSDKProposal
    }
    
    var modelSearchID: String? {
        return model.searchResultInfo.searchID
    }
}

struct SearchResultsViewModel {
    var model: JRSDKSearchResult
    
    var bestPrice: String?
    var originDestinationAirportsText: String?
    var travelDateText: String?
    var passengersCountText: String?
    var travelClassText: String?
    
    var tickets: [TicketViewModel] = []
    
    init(searchResult: JRSDKSearchResult) {
        self.model = searchResult
        self.update()
    }
    
    mutating func update() {
//        self.bestPrice = "\(self.model.bestPrice?.currency ?? "$") \(self.model.bestPrice?.value ?? 0.0))"
        self.bestPrice = self.model.bestPrice?.formattedPriceinUserCurrency()
        
        // Setting up TravelDateText
        let firstTravelSegment = self.model.searchResultInfo.searchInfo.travelSegments.firstObject as? JRSDKTravelSegment
        if let ts = firstTravelSegment {
            self.travelDateText = ts.departureDate.representation()
        }
        let lastTravelSegment = self.model.searchResultInfo.searchInfo.travelSegments.lastObject as? JRSDKTravelSegment
        if let ts = lastTravelSegment, self.model.searchResultInfo.searchInfo.travelSegments.count > 1
            && ts.destinationAirport == firstTravelSegment?.originAirport {
            // That's the return segment
            if let travelDateText = self.travelDateText {
                self.travelDateText = travelDateText + " - " + ts.departureDate.representation()
            }
        }
        
        // Setting up Origin - Destination airports text
        if let ts = firstTravelSegment {
            self.originDestinationAirportsText = "\(ts.originAirport.iata) - \(ts.destinationAirport.iata)"
        }
        
        // Setting up passengers text
        let si = self.model.searchResultInfo.searchInfo
        // TODO: plural localization
        self.passengersCountText = "\(si.adults + si.children + si.infants) \(NSLocalizedString("passenger(s)", comment: ""))"
        
        // Travel class
        self.travelClassText = travelClassRepresentation(travelClass: self.model.searchResultInfo.searchInfo.travelClass)
        
        //
        
        self.tickets = []
        for el in self.model.tickets {
            if let ticketModel = el as? JRSDKTicket {
                let ticketViewModel = TicketViewModel(model: ticketModel)
                self.tickets.append(ticketViewModel)
            }
        }
    }
}
