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
    var datePickerView: FSCalendar!
    @IBOutlet var departureButton: UIButton!
    @IBOutlet var returnButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    
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
    
    func addDatePickerView() {
        var utcCalendar = Calendar.current
        utcCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
        self.datePickerView = FSCalendar(frame: .null)
        self.datePickerView.translatesAutoresizingMaskIntoConstraints = false
        self.datePickerView.scrollDirection = .vertical
        self.datePickerView.allowsMultipleSelection = true
        
        self.view.addSubview(self.datePickerView)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.datePickerView.topAnchor.constraint(equalTo: self.departureButton.bottomAnchor, constant: 8.0),
            self.datePickerView.leftAnchor.constraint(equalTo: guide.leftAnchor),
            self.datePickerView.rightAnchor.constraint(equalTo: guide.rightAnchor),
            self.datePickerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
}


// DatePickerViewProtocol
extension DatePickerViewController: DatePickerViewProtocol {
    @IBAction func departureButtonTapped() {
        self.presenter.handleDepartureButtonTapped()
        datePickerView.reloadData()
    }
    
    @IBAction func returnButtonTapped() {
        self.presenter.handleReturnButtonTapped()
        datePickerView.reloadData()
    }
    
    @IBAction func dismissTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped() {
        self.presenter.handleDoneTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    func reloadData() {
        self.datePickerView.reloadData()
    }
}


// Lifecycle
extension DatePickerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addDatePickerView()
        self.closeButton.setImage(UIBarButtonItem.SystemItem.stop.image(), for: .normal)
        self.closeButton.setTitle("", for: .normal)
        
        self.datePickerView.delegate = self.presenter
        self.datePickerView.dataSource = self.presenter
    }
}
