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
        
        self.price = "₽\(proposal.price.priceInRUB())"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let departureDate = Date(timeIntervalSince1970: directFlightSegment.departureDateTimestamp.doubleValue)
        let arrivalDate = Date(timeIntervalSince1970: directFlightSegment.arrivalDateTimestamp.doubleValue)
        
        self.departureTime = dateFormatter.string(from: departureDate)
        self.arrivalTime = dateFormatter.string(from: arrivalDate)
        
        self.originIATA = flight.originAirport.iata
        self.destinationIATA = flight.destinationAirport.iata
        
        let hours = Int(directFlightSegment.totalDurationInMinutes / 60)
        let minutes = directFlightSegment.totalDurationInMinutes % 60
        self.flightDuration = "\(hours)h \(minutes)m"
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
    var tickets: [TicketViewModel] = []
    
    init(searchResult: JRSDKSearchResult) {
        self.model = searchResult
        self.update()
    }
    
    mutating func update() {
        self.bestPrice = "\(self.model.bestPrice?.currency ?? "$") \(self.model.bestPrice?.value ?? 0.0))"
        self.tickets = []
        for el in self.model.tickets {
            if let ticketModel = el as? JRSDKTicket {
                let ticketViewModel = TicketViewModel(model: ticketModel)
                self.tickets.append(ticketViewModel)
            }
        }
    }
}
