//
//  DatePicker.swift
//  Yafix
//
//  Created by Артём Зайцев on 22/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import RSDayFlow

class DatePicker: RSDFDatePickerView {
    var selection: (Date) -> Void
    
    init(frame: CGRect, selection: @escaping (Date) -> Void) {
        self.selection = selection
        super.init(frame: frame)
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}


extension DatePicker: RSDFDatePickerViewDelegate {
    func datePickerView(_ view: RSDFDatePickerView, didSelect date: Date) {
        print("SELECTED: \(date)")
        self.selection(date)
        self.removeFromSuperview()
    }
}


extension DatePicker: RSDFDatePickerViewDataSource {
    
}
