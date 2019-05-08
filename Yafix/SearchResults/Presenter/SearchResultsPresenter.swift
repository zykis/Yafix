//
//  SearchResultsPresenter.swift
//  Yafix
//
//  Created by Артём Зайцев on 27/04/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation
import AviasalesSDK

protocol SearchResultsViewProtocol: class {
    init(searchResult: JRSDKSearchResult)
}


protocol SearchResultsPresenterProtocol {
    init(view: SearchResultsViewProtocol, searchResult: JRSDKSearchResult)
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func ticketViewModel(at index: Int) -> TicketViewModel
}


class SearchResultsPresenter: SearchResultsPresenterProtocol {
    unowned let view: SearchResultsViewProtocol
    var viewModel: SearchResultsViewModel
    
    required init(view: SearchResultsViewProtocol, searchResult: JRSDKSearchResult) {
        self.view = view
        self.viewModel = SearchResultsViewModel(searchResult: searchResult)
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if section == 0 {
            return viewModel.tickets.count
        } else {
            return 0
        }
    }
    
    func ticketViewModel(at index: Int) -> TicketViewModel {
        return viewModel.tickets[index]
    }
}
