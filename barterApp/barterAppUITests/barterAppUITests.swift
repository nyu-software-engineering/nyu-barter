//
//  barterAppUITests.swift
//  barterAppUITests
//
//  Created by Kevin Maldjian on 2/24/19.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import XCTest

class barterAppUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHomeFeed() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        app.launch()
        //XCTAssertTrue(app.isDisplayingHomeFeed)
        app.swipeDown()
        app.swipeUp()
        app.swipeDown()
        app.swipeDown()
        app.swipeDown()
        app.swipeDown()
        app.swipeUp()
        app.swipeUp()
        app.tap()
        app.tap()
    }
    
    
    

}
