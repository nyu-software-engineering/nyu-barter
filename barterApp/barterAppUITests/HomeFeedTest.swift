//
//  HomeFeedTest.swift
//  barterAppUITests
//
//  Created by Kevin Maldjian on 3/4/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import XCTest

extension XCUIApplication {
    var isDisplayingHomeFeed: Bool {
        return otherElements["homeFeed"].exists
    }
}
