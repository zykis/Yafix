//
//  DatePickerPresenter.swift
//  Yafix
//
//  Created by Артём Зайцев on 29/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation

import FSCalendar


enum DateType {
    case Departure
    case Return
}


protocol DatePickerViewProtocol {
    init(departureDate: Date?, returnDate: Date?, dateType: DateType, selection: @escaping (Date, DateType) -> Void)
    func reloadData()
    func animateDepartureButtonTapped()
    func animateReturnButtonTapped()
    func updateDepartureLabel(dateRepresentation: String)
    func updateReturnLabel(dateRepresentation: String)
    func selectDate(date: Date)
    func deselectDate(date: Date)
}


protocol DatePickerPresenterProtocol {
    init(departureDate: Date?, returnDate: Date?, dateType: DateType, selection: @escaping (Date, DateType) -> Void)
    func handleDoneTapped()
    func handleDepartureButtonTapped()
    func handleReturnButtonTapped()
    func handleViewDidLoad()
}


class DatePickerPresenter: NSObject, DatePickerPresenterProtocol {
    var view: DatePickerViewProtocol!
    var currentType: DateType = .Departure {
        didSet {
            if currentType == .Return {
                self.view.animateReturnButtonTapped()
            } else {
                self.view.animateDepartureButtonTapped()
            }
        }
    }
    var departureDate: Date? {
        willSet {
            if let departureDate = departureDate {
                self.view.deselectDate(date: departureDate)
            }
        }
        didSet {
            self.view.updateDepartureLabel(dateRepresentation: departureDate?.representation() ?? Date().representation())
        }
    }
    var returnDate: Date? {
        willSet {
            if let returnDate = self.returnDate {
                self.view.deselectDate(date: returnDate)
            }
        }
        didSet {
            self.view.updateReturnLabel(dateRepresentation: returnDate?.representation() ?? NSLocalizedString("optional", comment: ""))
        }
    }
    let selection: (Date, DateType) -> Void
    
    required init(departureDate: Date?, returnDate: Date?, dateType: DateType, selection: @escaping (Date, DateType) -> Void) {
        self.departureDate = departureDate
        self.returnDate = returnDate
        self.currentType = dateType
        self.selection = selection
    }
    
    func handleDoneTapped() {
        if let departureDate = self.departureDate {
            self.selection(departureDate, .Departure)
        }
        if let returnDate = self.returnDate {
            self.selection(returnDate, .Return)
        }
    }
    
    func handleDepartureButtonTapped() {
        // TODO: set selected dates, if were previously selected
        self.currentType = .Departure
    }

    func handleReturnButtonTapped() {
        self.currentType = .Return
    }
    
    func handleViewDidLoad() {
        // Select departure and return date, if both not nil
        if self.departureDate != nil {
            self.view.selectDate(date: departureDate!)
            self.view.updateDepartureLabel(dateRepresentation: departureDate?.representation() ?? Date().representation())
        }
        if self.returnDate != nil {
            self.view.selectDate(date: returnDate!)
            self.view.updateReturnLabel(dateRepresentation: returnDate?.representation() ?? "Optional")
        }
        
        if self.currentType == .Return {
            self.view.animateReturnButtonTapped()
        } else {
            self.view.animateDepartureButtonTapped()
        }
    }
}


// FSCalendarDelegate
extension DatePickerPresenter: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("selected date: \(date)")
        switch currentType {
        case .Departure:
            self.departureDate = date
            self.currentType = .Return
            break
        case .Return:
            self.returnDate = date
            break
        }
        
        self.view.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        if date < calendar.startOfDay(for: Date()) {
            return false
        }
        
        // Prevent from selecting return date earlier then departure
        if let departureDate = self.departureDate, self.currentType == .Return && date < departureDate {
            return false
        }
        
        // Prevent from selecting departure date later, then return date
        if let returnDate = self.returnDate, self.currentType == .Departure && date > returnDate {
            return false
        }
        
        return true
    }
}


// FSCalendarDataSource
extension DatePickerPresenter: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        /// TODO: configure cell to pick date range
    }
}
