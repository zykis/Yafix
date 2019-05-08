//
//  AirportPickerPresenter.swift
//  Yafix
//
//  Created by Артём Зайцев on 02/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation
import AviasalesSDK

protocol AirportPickerViewProtocol: class {
    init(type: AirportType, selection: @escaping (JRSDKAirport) -> Void)
    func reloadData()
    func dismiss()
    func setTableViewHidden(hidden: Bool)
}

protocol AirportPickerPresenterProtocol {
    init(view: AirportPickerViewProtocol, type: AirportType, selection: @escaping (JRSDKAirport) -> Void)
    func set(searchString: String)
    func numberOfRowsInSection(section: Int) -> Int
    func viewModelForCell(at indexPath: IndexPath) -> AirportPickerCellViewModel
    func select(at indexPath: IndexPath)
}

class AirportPickerPresenter: NSObject, AirportPickerPresenterProtocol {
    weak var view: AirportPickerViewProtocol!
    
    lazy var searchPerformer: AviasalesAirportsSearchPerformer = {
        return AviasalesAirportsSearchPerformer.init(searchLocationType: [.airport, .city], delegate: self)
    }()
    
    let type: AirportType
    let selection: (JRSDKAirport) -> Void
    
    var searchString: String
    
    var viewModel: [AirportPickerCellViewModel]
    
    required init(view: AirportPickerViewProtocol, type: AirportType, selection: @escaping (JRSDKAirport) -> Void) {
        self.view = view
        self.type = type
        self.selection = selection
        self.searchString = ""
    
        self.viewModel = []
    }
    
    func set(searchString: String) {
        searchPerformer.cancelSearch()
        
        self.searchString = searchString
        
        if searchString.isEmpty {
            searchPerformer.cancelSearch()
        } else {
            searchPerformer.searchAirports(with: self.searchString)
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return viewModel.count
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> AirportPickerCellViewModel {
        return viewModel[indexPath.row]
    }
    
    func select(at indexPath: IndexPath) {
        let vm = self.viewModel[indexPath.row]
        self.selection(vm.model)
        self.view.dismiss()
    }
}


extension AirportPickerPresenter: AviasalesSearchPerformerDelegate {
    func airportsSearchPerformer(_ airportsSearchPerformer: AviasalesAirportsSearchPerformer!, didFound locations: [JRSDKLocation]!, final: Bool) {
        self.viewModel = []
        for l in locations {
            if let airport = l as? JRSDKAirport, l.flightable == true {
                let cell = AirportPickerCellViewModel(airport: airport)
                self.viewModel.append(cell)
            }
        }
        self.view.reloadData()
        if self.viewModel.isEmpty {
            self.view.setTableViewHidden(hidden: true)
        } else {
            self.view.setTableViewHidden(hidden: false)
        }
    }
}
