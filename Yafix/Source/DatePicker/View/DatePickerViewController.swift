//
//  DatePicker.swift
//  Yafix
//
//  Created by Артём Зайцев on 22/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import RSDayFlow

class DatePickerViewController: UIViewController, DatePickerViewProtocol  {
    let presenter: DatePickerPresenter!
    @IBOutlet var rsdfDatePickerView: RSDFDatePickerView!
    
    required init(departureDate: Date?, returnDate: Date?, selection: @escaping (Date, DateType) -> Void) {
        self.presenter = DatePickerPresenter(departureDate: departureDate,
                                             returnDate: returnDate,
                                             selection: selection)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    @IBAction func departureButtonTapped() {
        self.presenter.handleDepartureButtonTapped()
    }
    
    @IBAction func returnButtonTapped() {
        self.presenter.handleReturnButtonTapped()
    }
    
    @IBAction func dismissTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}


// Lifecycle
extension DatePickerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rsdfDatePickerView.delegate = self.presenter
        self.rsdfDatePickerView.dataSource = self.presenter
    }
}
