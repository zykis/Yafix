//
//  AirportPickerCell.swift
//  Yafix
//
//  Created by Артём Зайцев on 04/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

protocol AirportPickerCellProtocol {
    func setup(viewModel: AirportPickerCellViewModel)
}

class AirportPickerCell: UITableViewCell, AirportPickerCellProtocol {
    @IBOutlet var IATALabel: UILabel!
    @IBOutlet var airportDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.IATALabel.layer.cornerRadius = 4.0
        self.IATALabel.layer.borderWidth = 1.0
        self.IATALabel.layer.borderColor = inactiveColor.cgColor
    }
    
    func setup(viewModel: AirportPickerCellViewModel) {
        IATALabel.text = viewModel.iata
        airportDescriptionLabel.text = viewModel.description
    }
}
