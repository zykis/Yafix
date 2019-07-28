//
//  DatePicker.swift
//  Yafix
//
//  Created by Артём Зайцев on 22/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

//import RSDayFlow
import FSCalendar

class DatePickerViewController: UIViewController  {
    let presenter: DatePickerPresenter!
    @IBOutlet weak var datePickerView: FSCalendar!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var verticalLeftSeparator: UIView!
    @IBOutlet weak var verticalRightSeparator: UIView!
    @IBOutlet weak var departureVerticalStack: UIStackView!
    @IBOutlet weak var returnVerticalStack: UIStackView!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var returnLabel: UILabel!
    
    required init(departureDate: Date?, returnDate: Date?, dateType: DateType, selection: @escaping (Date, DateType) -> Void) {
        self.presenter = DatePickerPresenter(departureDate: departureDate,
                                             returnDate: returnDate,
                                             dateType: dateType,
                                             selection: selection)
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    func setupDatePickerView() {
        self.datePickerView.scrollDirection = .vertical
    }
}


// DatePickerViewProtocol
extension DatePickerViewController: DatePickerViewProtocol {
    @objc func departureButtonTapped() {
        self.presenter.handleDepartureButtonTapped()
        
        self.animateDepartureButtonTapped()
        
        datePickerView.reloadData()
    }
    
    @objc func returnButtonTapped() {
        self.presenter.handleReturnButtonTapped()
        
        self.animateReturnButtonTapped()
        
        datePickerView.reloadData()
    }
    
    @objc func dismissTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped() {
        self.presenter.handleDoneTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    func reloadData() {
        self.datePickerView.reloadData()
    }
    
    func animateDepartureButtonTapped() {
        // TODO: Animation
        self.verticalLeftSeparator.backgroundColor = activeColor
        self.verticalRightSeparator.backgroundColor = inactiveColor
    }
    
    func animateReturnButtonTapped() {
        // TODO: Animation
        self.verticalLeftSeparator.backgroundColor = inactiveColor
        self.verticalRightSeparator.backgroundColor = activeColor
    }
    
    func updateDepartureLabel(dateRepresentation: String) {
        self.departureLabel.text = dateRepresentation
    }
    
    func updateReturnLabel(dateRepresentation: String) {
        self.returnLabel.text = dateRepresentation
    }
}


// Lifecycle
extension DatePickerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDatePickerView()
        self.closeButton.addTarget(self, action: #selector(DatePickerViewController.dismissTapped), for: .touchUpInside)
        
        self.departureVerticalStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DatePickerViewController.departureButtonTapped)))
        self.returnVerticalStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DatePickerViewController.returnButtonTapped)))
        
        self.datePickerView.delegate = self.presenter
        self.datePickerView.dataSource = self.presenter
    }
}
