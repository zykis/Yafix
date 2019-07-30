//
//  SearchResultCell.swift
//  Yafix
//
//  Created by Артём Зайцев on 08/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit
import AviasalesSDK


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
        self.setImage(imageView: self.airlineIcon, airline: viewModel.model.mainAirline)
        self.departureTimeLabel.text = viewModel.departureTime
        self.originIATALabel.text = viewModel.originIATA
        self.arrivalTimeLabel.text = viewModel.arrivalTime
        self.destinationIATALabel.text = viewModel.destinationIATA
        self.flightDurationLabel.text = viewModel.flightDuration
    }
    
    private func setImage(imageView: UIImageView, airline: JRSDKAirline) {
        let scale = UIScreen.main.scale
        let iconSize = __CGSizeApplyAffineTransform(self.airlineIcon.bounds.size, CGAffineTransform(scaleX: scale, y: scale))
        let airlineIconUrlString = JRSDKModelUtils.airlineLogoUrl(withIATA: airline.iata, size: iconSize)
        let airlineIconUrl = URL(string: airlineIconUrlString)
        
        airlineIcon.image = nil
        airlineIcon.highlightedImage = nil
        airlineIcon.isHidden = true
        if let url = airlineIconUrl{
            airlineIcon.downloadAndSetupImage(with: url) { (ok) in
                if ok {
                    self.airlineIcon.isHidden = false
                }
            }
        }
    }
}
