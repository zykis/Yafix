//
//  SearchResultsViewController.swift
//  Yafix
//
//  Created by Артём Зайцев on 27/04/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit
import AviasalesSDK

class SearchResultsViewController: UIViewController, SearchResultsViewProtocol {
    @IBOutlet var tableView: UITableView!
    var presenter: SearchResultsPresenterProtocol!
    
    required init(searchResult: JRSDKSearchResult) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = SearchResultsPresenter(view: self, searchResult: searchResult)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    func ticketTapped(at index: Int) {
        self.presenter.handleTicketTapped(at: index)
    }
}

// MARK: Lifecycle
extension SearchResultsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
}


// MARK: Private Initialization
extension SearchResultsViewController {
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: SearchResultCell.identifier, bundle: nil), forCellReuseIdentifier: SearchResultCell.identifier)
    }
}


// MARK: UITableViewDataSource
extension SearchResultsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ticketViewModel = self.presenter.ticketViewModel(at: indexPath.row)
        let cell = self.tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier) as! SearchResultCell
        cell.setup(viewModel: ticketViewModel)
        return cell
    }
}


// MARK: UITableViewDelegate
extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.ticketTapped(at: indexPath.row)
    }
}
