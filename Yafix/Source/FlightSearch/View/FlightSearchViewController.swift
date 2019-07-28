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
    @IBOutlet weak var passengersStackView: UIStackView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.presenter = FlightSearchPresenter(view: self, viewModel: FlightSearchViewModel())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    @IBAction func swapAirports() {
        self.presenter.handleSwapAirports()
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
        self.passengersStackView.isUserInteractionEnabled = true
        self.passengersStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(passengersTapped)))
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


// MARK: PassengersPickerView
extension FlightSearchViewController {
    @objc func passengersTapped() {
        // Adding shadow to main view
        let shadow = UIView(frame: self.view.frame)
        // Setting up accessibilityIdentifier to remove view later
        shadow.accessibilityIdentifier = "shadow"
        shadow.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        shadow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(passengersDoneTapped)))
        self.view.addSubview(shadow)
        
        // Presenting passenger picker
        let passengersPickerView: PassengersPickerView = PassengersPickerView.instanceFromNib()
        // Connecting done button
        passengersPickerView.doneButton.addTarget(self, action: #selector(passengersDoneTapped), for: .touchUpInside)
        // Getting passengers info from model (not cool, right)
        let passengers: Passengers = self.presenter.getPassengers()
        // Updating view with it
        passengersPickerView.updateWith(passengers: passengers)
        
        // Setting up accessibilityIdentifier to remove view later
        passengersPickerView.accessibilityIdentifier = "passengersPickerView"
        
        let targetFrame = CGRect(x: 0,
                                 y: self.view.bounds.height - passengersPickerView.bounds.height + 24,
                                 width: self.view.bounds.width,
                                 height: self.view.bounds.height)
        
        let passengersPickerViewFrame = CGRect(x: 0,
                                               y: self.view.bounds.height,
                                               width: self.view.bounds.width,
                                               height: self.view.bounds.height)
        
        passengersPickerView.frame = passengersPickerViewFrame
        passengersPickerView.layer.cornerRadius = 16.0
        self.view.addSubview(passengersPickerView)
        
        // Animation
        UIView.animate(withDuration: 0.2) {
            shadow.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
            passengersPickerView.frame = targetFrame
        }
    }
    
    @IBAction func passengersDoneTapped() {
        passengersPickerViewDismiss()
    }
    
    func passengersPickerViewDismiss() {
        var shadow: UIView? = nil
        var passengersPickerView: PassengersPickerView? = nil
        
        // looking for subviews with accessibility identifiers
        for subview in self.view.subviews {
            if subview.accessibilityIdentifier == "shadow" {
                shadow = subview
            }
            if subview.accessibilityIdentifier == "passengersPickerView" {
                passengersPickerView = subview as? PassengersPickerView
            }
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            shadow?.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
            passengersPickerView?.frame = CGRect(x: 0,
                                                 y: self.view.bounds.height,
                                                 width: self.view.bounds.width,
                                                 height: self.view.bounds.height)
        }) { (finished) in
            // Update model with new passengers count
            self.presenter.updatePassengers(passengers: passengersPickerView?.getPassengers() ?? Passengers(adults: 0, children: 0, infants: 0))
            // Remove subviews
            shadow?.removeFromSuperview()
            passengersPickerView?.removeFromSuperview()
        }
    }
}
