//
//  FlightSearchPresenter.swift
//  Yafix
//
//  Created by Артём Зайцев on 27/04/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation
import AviasalesSDK

enum AirportType {
    case origin
    case destination
}

protocol FlightSeachView: class {
    func searchButtonTapped()
    func originAirportTapped()
    func destinationAirportTapped()
    func updateWithViewModel(viewModel: FlightSearchViewModel)
    func presentLoadingViewWithSearchInfo(searchInfo: JRSDKSearchInfo)
    func presentDepartureDatePicker()
    func presentReturnDatePicker()
}


protocol FlightSearchViewPresenter {
    init(view: FlightSeachView, viewModel: FlightSearchViewModel)
    func buildSearchInfo() -> JRSDKSearchInfo?
    func handleSearch()
    func handleAirportSelected(type: AirportType, airport: JRSDKAirport)
    func handleLoad()
    func handleDepartureDateSelected(departureDate: Date)
    func handleReturnDateSelected(returnDate: Date)
}


class FlightSearchPresenter: NSObject, FlightSearchViewPresenter {
    unowned let view: FlightSeachView
    var viewModel: FlightSearchViewModel
    
    required init(view: FlightSeachView, viewModel: FlightSearchViewModel) {
        self.view = view
        self.viewModel = viewModel
    }
    
    func buildSearchInfo() -> JRSDKSearchInfo? {
        let travelSegmentBuilder = viewModel.model.travelSegmentBuilder
        let searchInfoBuilder = viewModel.model.searchInfoBuilder
        if let returnDate = viewModel.model.returnDate {
            let returnTravelSegmentBuilder = JRSDKTravelSegmentBuilder()
            returnTravelSegmentBuilder.originAirport = travelSegmentBuilder.destinationAirport
            returnTravelSegmentBuilder.destinationAirport = travelSegmentBuilder.originAirport
            returnTravelSegmentBuilder.departureDate = returnDate
            
            searchInfoBuilder.travelSegments = NSOrderedSet(array: [travelSegmentBuilder.build()!, returnTravelSegmentBuilder.build()!])
        } else {
            searchInfoBuilder.travelSegments = NSOrderedSet(object: travelSegmentBuilder.build()!)
        }
        
        return searchInfoBuilder.build()
    }
    
    func handleLoad() {
        self.view.updateWithViewModel(viewModel: self.viewModel)
    }
    
    func handleSearch() {
        if let searchInfo = buildSearchInfo() {
            view.presentLoadingViewWithSearchInfo(searchInfo: searchInfo)
        } else {
            fatalError("Couldnt build searchInfo")
        }
    }
    
    func handleAirportSelected(type: AirportType, airport: JRSDKAirport) {
        switch type {
        case .origin:
            viewModel.model.travelSegmentBuilder.originAirport = airport
        case .destination:
            viewModel.model.travelSegmentBuilder.destinationAirport = airport
        }
        viewModel.update()
        self.view.updateWithViewModel(viewModel: self.viewModel)
    }
    
    func handleDepartureDateSelected(departureDate: Date) {
        viewModel.model.travelSegmentBuilder.departureDate = departureDate
        viewModel.update()
        self.view.updateWithViewModel(viewModel: self.viewModel)
    }
    
    func handleReturnDateSelected(returnDate: Date) {
        viewModel.model.returnDate = returnDate
        viewModel.update()
        self.view.updateWithViewModel(viewModel: self.viewModel)
    }
}
