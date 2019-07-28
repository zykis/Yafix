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
}


protocol DatePickerPresenterProtocol {
    init(departureDate: Date?, returnDate: Date?, dateType: DateType, selection: @escaping (Date, DateType) -> Void)
    func handleDoneTapped()
    func handleDepartureButtonTapped()
    func handleReturnButtonTapped()
}


class DatePickerPresenter: NSObject, DatePickerPresenterProtocol {
    var view: DatePickerViewProtocol!
    var currentType: DateType = .Departure
    var departureDate: Date?
    var returnDate: Date?
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
        self.currentType = .Departure
    }

    func handleReturnButtonTapped() {
        self.currentType = .Return
    }
}


// FSCalendarDelegate
extension DatePickerPresenter: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        switch currentType {
        case .Departure:
            self.departureDate = date
        case .Return:
            self.returnDate = date
        }
        
        self.view.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        return (date >= calendar.startOfDay(for: Date()))
    }
}


// FSCalendarDataSource
extension DatePickerPresenter: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        /// TODO: configure cell to pick date range
    }
}