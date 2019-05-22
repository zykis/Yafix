//
//  ViewController.swift
//  Yafix
//
//  Created by Артём Зайцев on 27/04/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit
import AviasalesSDK
import RSDayFlow

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchButton.addTarget(self, action: #selector(FlightSearchViewController.searchButtonTapped), for: .touchUpInside)
        self.originIATALabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(originAirportTapped)))
        self.originIATALabel.isUserInteractionEnabled = true
        self.destinationIATALabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(destinationAirportTapped)))
        self.destinationIATALabel.isUserInteractionEnabled = true
        self.departureDateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentDepartureDatePicker)))
        self.departureDateLabel.isUserInteractionEnabled = true
        self.returnLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentReturnDatePicker)))
        self.returnLabel.isUserInteractionEnabled = true
        self.navigationController?.isNavigationBarHidden = true
        self.presenter.handleLoad()
    }
    
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
    
    @objc func presentDepartureDatePicker() {
        let datePickerView = DatePicker(frame: self.view.bounds, selection: { (date: Date) -> Void in
            self.presenter.handleDepartureDateSelected(departureDate: date)
        })
        self.view.addSubview(datePickerView)
    }
    
    @objc func presentReturnDatePicker() {
        let datePickerView = DatePicker(frame: self.view.bounds, selection: { (date: Date) -> Void in
            self.presenter.handleReturnDateSelected(returnDate: date)
        })
        self.view.addSubview(datePickerView)
    }
}
