//
//  SearchResultCell.swift
//  Yafix
//
//  Created by Артём Зайцев on 08/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var airlineLabel: UILabel!
    @IBOutlet var airlineIcon: UIImageView!
    
    @IBOutlet var departureTimeLabel: UILabel!
    @IBOutlet var originIATALabel: UILabel!
    @IBOutlet var arrivalTimeLabel: UILabel!
    @IBOutlet var destinationIATALabel: UILabel!
    
    @IBOutlet var flightDurationLabel: UILabel!
    
    func setup(viewModel: TicketViewModel) {
        self.priceLabel.text = viewModel.price
        self.airlineLabel.text = viewModel.airline
//        self.airlineIcon.image = UIImage(named: viewModel.airlineIcon)
        self.departureTimeLabel.text = viewModel.departureTime
        self.originIATALabel.text = viewModel.originIATA
        self.arrivalTimeLabel.text = viewModel.arrivalTime
        self.destinationIATALabel.text = viewModel.destinationIATA
        self.flightDurationLabel.text = viewModel.flightDuration
    }
}
