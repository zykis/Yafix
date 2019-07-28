//
//  TravelClassPickerView.swift
//  Yafix
//
//  Created by Артём Зайцев on 28.07.2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

enum TravelClass {
    case Economy
    case PremiumEconomy
    case Business
    case FirstClass
}

class TravelClassPickerView: UIView {
    var travelClass: TravelClass = .Economy {
        didSet {
            economyImageView.alpha = 0.0
            premiumEconomyImageView.alpha = 0.0
            businessImageView.alpha = 0.0
            firstClassImageView.alpha = 0.0
            
            switch travelClass {
            case .Economy:
                economyImageView.alpha = 1.0
                break
            case .PremiumEconomy:
                premiumEconomyImageView.alpha = 1.0
                break
            case .Business:
                businessImageView.alpha = 1.0
                break
            case .FirstClass:
                firstClassImageView.alpha = 1.0
            }
        }
    }
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var economyImageView: UIImageView!
    @IBOutlet weak var premiumEconomyImageView: UIImageView!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var firstClassImageView: UIImageView!
    
    @IBOutlet weak var economyStackView: UIStackView!
    @IBOutlet weak var premiumEconomyStackView: UIStackView!
    @IBOutlet weak var businessStackView: UIStackView!
    @IBOutlet weak var firstClassStackView: UIStackView!
    
    class func instanceFromNib() -> TravelClassPickerView {
        return UINib(nibName: "TravelClassPickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TravelClassPickerView
    }
    
    override func awakeFromNib() {
        economyStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(travelClassEconomyTapped)))
        premiumEconomyStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(travelClassPremiumEconomyTapped)))
        businessStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(travelClassBusinessTapped)))
        firstClassStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(travelClassFirstClassTapped)))
    }
    
    func updateWith(travelClass: TravelClass) {
        self.travelClass = travelClass
    }
    
    func getTravelClass() -> TravelClass {
        return self.travelClass
    }
    
    @objc func travelClassEconomyTapped() {
        self.travelClass = .Economy
    }
    
    @objc func travelClassPremiumEconomyTapped() {
        self.travelClass = .PremiumEconomy
    }
    
    @objc func travelClassBusinessTapped() {
        self.travelClass = .Business
    }
    
    @objc func travelClassFirstClassTapped() {
        self.travelClass = .FirstClass
    }
}
