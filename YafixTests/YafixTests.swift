//
//  YafixTests.swift
//  YafixTests
//
//  Created by Артём Зайцев on 27/04/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import XCTest
@testable import Yafix
@testable import AviasalesSDK

class FlightSearchPresenterTests: XCTestCase {
    var view: FlightSearchViewController!

    override func setUp() {
        super.setUp()
        view = FlightSearchViewController(nibName: nil, bundle: nil)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        view = nil
        super.tearDown()
    }

    func testBuildSearchInfo() {
        // 1. given
        let sib = JRSDKSearchInfoBuilder()
        let tsb = JRSDKTravelSegmentBuilder()
        tsb.originAirport = AviasalesSDK.sharedInstance().airportsStorage.findAnything(byIATA: "MOW")
        tsb.destinationAirport = AviasalesSDK.sharedInstance().airportsStorage.findAnything(byIATA: "LED")
        tsb.departureDate = Date()
        sib.travelSegments = NSOrderedSet(object: tsb.build())
        sib.adults = 
    }
}
