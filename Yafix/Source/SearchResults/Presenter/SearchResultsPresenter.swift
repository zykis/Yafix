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
    func ticketTapped(at index: Int)
    func updateWithViewModel(viewModel: SearchResultsViewModel)
}


protocol SearchResultsPresenterProtocol {
    init(view: SearchResultsViewProtocol, searchResult: JRSDKSearchResult)
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func ticketViewModel(at index: Int) -> TicketViewModel
    func handleTicketTapped(at index: Int)
    func handleViewDidLoad()
}


class SearchResultsPresenter: NSObject, SearchResultsPresenterProtocol {
    unowned let view: SearchResultsViewProtocol
    var viewModel: SearchResultsViewModel
    var purchasePerformer: AviasalesSDKPurchasePerformer?
    
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
    
    func handleTicketTapped(at index: Int) {
        let ticketViewModel = viewModel.tickets[index]
        let proposal = ticketViewModel.modelProposal
        let searchID = ticketViewModel.modelSearchID
        self.purchasePerformer = AviasalesSDKPurchasePerformer(proposal: proposal, searchId: searchID)
        self.purchasePerformer?.perform(with: self)
    }
    
    func handleViewDidLoad() {
        self.view.updateWithViewModel(viewModel: self.viewModel)
    }
}


// MARK: AviasalesSDKPurchasePerformerDelegate
extension SearchResultsPresenter: AviasalesSDKPurchasePerformerDelegate {
    func purchasePerformer(_ performer: AviasalesSDKPurchasePerformer!, didFinishWith URLRequest: URLRequest!, clickID: String!) {
        if let url = URLRequest.url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func purchasePerformer(_ performer: AviasalesSDKPurchasePerformer!, didFailWithError error: Error!) {
        print(error.localizedDescription)
    }
}
