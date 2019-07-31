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
    @IBOutlet var originDestinationLabel: UILabel!
    @IBOutlet var travelDateLabel: UILabel!
    @IBOutlet var passengerCountLabel: UILabel!
    @IBOutlet var travelClassLabel: UILabel!
    
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
    
    @IBAction func jumpToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func updateWithViewModel(viewModel: SearchResultsViewModel) {
        self.originDestinationLabel.text = viewModel.originDestinationAirportsText
        self.travelDateLabel.text = viewModel.travelDateText
        self.passengerCountLabel.text = viewModel.passengersCountText
        self.travelClassLabel.text = viewModel.travelClassText
    }
}


// MARK: Lifecycle
extension SearchResultsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.presenter.handleViewDidLoad()
    }
}


// MARK: Private Initialization
extension SearchResultsViewController {
    private func setupTableView() {
        let background = UIView(frame: CGRect(x: 0,
                                              y: -480,
                                              width: self.tableView.bounds.width,
                                              height: self.tableView.bounds.height + 480 * 2))
        background.backgroundColor = backgroundColor
        self.tableView.backgroundView = background
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: SearchResultCell.identifier, bundle: nil), forCellReuseIdentifier: SearchResultCell.identifier)
    }
}


// MARK: UITableViewDataSource
extension SearchResultsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.numberOfRowsInSection(section: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ticketViewModel = self.presenter.ticketViewModel(at: indexPath.section)
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
        self.ticketTapped(at: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: .zero)
        header.backgroundColor = backgroundColor
        return header
    }
}
