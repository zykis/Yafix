//
//  DatePickerPresenter.swift
//  Yafix
//
//  Created by Артём Зайцев on 29/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation
import RSDayFlow


enum DateType {
    case Departure
    case Return
}


protocol DatePickerViewProtocol {
    init(departureDate: Date?, returnDate: Date?, selection: @escaping (Date, DateType) -> Void)
}


protocol DatePickerPresenterProtocol {
    init(departureDate: Date?, returnDate: Date?, selection: @escaping (Date, DateType) -> Void)
    func handleDepartureButtonTapped()
    func handleReturnButtonTapped()
}


class DatePickerPresenter: NSObject, DatePickerPresenterProtocol {
    var currentType: DateType = .Departure
    var departureDate: Date?
    var returnDate: Date?
    let selection: (Date, DateType) -> Void
    
    required init(departureDate: Date?, returnDate: Date?, selection: @escaping (Date, DateType) -> Void) {
        self.departureDate = departureDate
        self.returnDate = returnDate
        self.selection = selection
    }
    
    func handleDepartureButtonTapped() {
        self.currentType = .Departure
    }
    
    func handleReturnButtonTapped() {
        self.currentType = .Return
    }
}


// RSDFDatePickerViewDelegate
extension DatePickerPresenter: RSDFDatePickerViewDelegate {
    func datePickerView(_ view: RSDFDatePickerView, didSelect date: Date) {
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: Date())
        let minutes = calendar.component(.minute, from: Date())
        let seconds = calendar.component(.second, from: Date())
        let dateWithCurrentTime = date + TimeInterval(hours * 3600 + minutes * 60 + seconds)
        
        switch currentType {
        case .Departure:
            self.departureDate = dateWithCurrentTime
        case .Return:
            self.returnDate = dateWithCurrentTime
        }
        
        self.selection(dateWithCurrentTime, currentType)
    }
    
    func datePickerView(_ view: RSDFDatePickerView, shouldSelect date: Date) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        return (date >= calendar.startOfDay(for: Date()))
    }
    
    func datePickerView(_ view: RSDFDatePickerView, shouldHighlight date: Date) -> Bool {
        return true
    }
}

// RSDFDatePickerViewDataSource
extension DatePickerPresenter: RSDFDatePickerViewDataSource {
    func datePickerView(_ view: RSDFDatePickerView, shouldMark date: Date) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        if let returnDate = self.returnDate, let departureDate = self.departureDate {
            let selected = calendar.startOfDay(for: date)
            let dep = calendar.startOfDay(for: departureDate)
            let ret = calendar.startOfDay(for: returnDate)
            let rv = ((selected >= dep) && (selected <= ret))
            return rv
        }
        
        if let departureDate = self.departureDate {
            return calendar.startOfDay(for: date) == calendar.startOfDay(for: departureDate)
        }
        
        if let returnDate = self.returnDate {
            return calendar.startOfDay(for: date) == calendar.startOfDay(for: returnDate)
        }
        
        return false
    }
    
    func datePickerView(_ view: RSDFDatePickerView, markImageColorFor date: Date) -> UIColor {
        return UIColor.green
    }
}
