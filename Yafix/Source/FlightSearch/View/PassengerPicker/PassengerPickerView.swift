//
//  PassengerPickerView.swift
//  Yafix
//
//  Created by Артём Зайцев on 28.07.2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

class PassengersPickerView: UIView {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var adultsLabel: UILabel!
    @IBOutlet weak var childrenLabel: UILabel!
    @IBOutlet weak var infantsLabel: UILabel!
    
    class func instanceFromNib() -> PassengersPickerView {
        return UINib(nibName: "PassengerPickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PassengersPickerView
    }
    
    func updateWith(passengers: Passengers) {
        self.adults = NSNumber(value: passengers.adults)
        self.children = NSNumber(value: passengers.children)
        self.infants = NSNumber(value: passengers.infants)
    }
    
    func getPassengers() -> Passengers {
        return Passengers(adults: self.adults.uintValue,
                          children: self.children.uintValue,
                          infants: self.infants.uintValue)
    }
    
    var adults: NSNumber = 0 {
        didSet {
            self.adultsLabel.text = "\(adults)"
        }
    }
    var children: NSNumber = 0 {
        didSet {
            self.childrenLabel.text = "\(children)"
        }
    }
    var infants: NSNumber = 0 {
        didSet {
            self.infantsLabel.text = "\(infants)"
        }
    }
    
    @IBAction func incrementAdults() {
        self.adults = NSNumber(value: self.adults.uintValue + 1)
    }
    
    @IBAction func decrementAdults() {
        // At least 1 adult should be presented
        if self.adults.uintValue == 1 { return }
        if self.adults.uintValue > 0 {
            self.adults = NSNumber(value: self.adults.uintValue - 1)
        }
    }
    
    @IBAction func incrementChildren() {
        self.children = NSNumber(value: self.children.uintValue + 1)
    }
    
    @IBAction func decrementChildren() {
        if self.children.uintValue > 0 {
            self.children = NSNumber(value: self.children.uintValue - 1)
        }
    }
    
    @IBAction func incrementInfants() {
        self.infants = NSNumber(value: self.infants.uintValue + 1)
    }
    
    @IBAction func decrementInfants() {
        if self.infants.uintValue > 0 {
            self.infants = NSNumber(value: self.infants.uintValue - 1)
        }
    }
}
