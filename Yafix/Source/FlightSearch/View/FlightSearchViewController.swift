//
//  ViewController.swift
//  Yafix
//
//  Created by Артём Зайцев on 27/04/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit
import AviasalesSDK
//import RSDayFlow
import FSCalendar

class FlightSearchViewController: UIViewController, FlightSeachView {
    var presenter: FlightSearchViewPresenter!
    
    @IBOutlet var originDescriptionLabel: UILabel!
    @IBOutlet var originIATALabel: UILabel!
    @IBOutlet var destinationDescriptionLabel: UILabel!
    @IBOutlet var destinationIATALabel: UILabel!
    @IBOutlet var departureDateLabel: UILabel!
    @IBOutlet var passengersLabel: UILabel!
    @IBOutlet var travelClassLabel: UILabel!
    @IBOutlet var returnLabel: UILabel!
    
    @IBOutlet var searchButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.presenter = FlightSearchPresenter(view: self, viewModel: FlightSearchViewModel())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}


// MARK: Lifecycle
extension FlightSearchViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchButton.addTarget(self, action: #selector(FlightSearchViewController.searchButtonTapped), for: .touchUpInside)
        self.originIATALabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(originAirportTapped)))
        self.originIATALabel.isUserInteractionEnabled = true
        self.destinationIATALabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(destinationAirportTapped)))
        self.destinationIATALabel.isUserInteractionEnabled = true
        self.departureDateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(departureDateTapped)))
        self.departureDateLabel.isUserInteractionEnabled = true
        self.returnLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnDateTapped)))
        self.returnLabel.isUserInteractionEnabled = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.presenter.handleLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}


// MARK: FlightSearchViewProtocol
extension FlightSearchViewController {
    @objc func searchButtonTapped() {
        self.presenter.handleSearch()
    }
    
    @objc func originAirportTapped() {
        let picker = AirportPickerViewController(type: .origin) { (airport: JRSDKAirport) in
            self.presenter.handleAirportSelected(type: .origin, airport: airport)
        }
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func destinationAirportTapped() {
        let picker = AirportPickerViewController(type: .destination) { (airport: JRSDKAirport) in
            self.presenter.handleAirportSelected(type: .destination, airport: airport)
        }
        self.present(picker, animated: true, completion: nil)
    }
    
    func updateWithViewModel(viewModel: FlightSearchViewModel) {
        self.originDescriptionLabel.text = viewModel.originAirportDescription
        self.originIATALabel.text = viewModel.originAirportIATA
        self.destinationDescriptionLabel.text = viewModel.destinationAirportDescription
        self.destinationIATALabel.text = viewModel.destinationAirportIATA
        self.departureDateLabel.text = viewModel.departureDate
        self.passengersLabel.text = viewModel.passengers
        self.travelClassLabel.text = viewModel.travelClass
        self.returnLabel.text = viewModel.returnDate
    }
    
    func presentLoadingViewWithSearchInfo(searchInfo: JRSDKSearchInfo) {
        let loadingView = LoadingViewController(searchInfo: searchInfo)
        self.navigationController?.pushViewController(loadingView, animated: true)
    }
    
    @objc func departureDateTapped() {
        self.presenter.handleDepartureDateTapped()
    }
    
    @objc func returnDateTapped() {
        self.presenter.handleReturnDateTapped()
    }
    
    func presentDatePicker(departureDate: Date?, returnDate: Date?, dateType: DateType) {
        let dp = DatePickerViewController(departureDate: departureDate, returnDate: returnDate, dateType: dateType) { (date, type) in
            self.presenter.handleDateSelected(date: date, type: type)
        }
        self.present(dp, animated: true, completion: nil)
    }
}
