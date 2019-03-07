//
//  barterAppTesting.swift
//  barterAppTesting
//
//  Created by William Cho on 2019-03-05.
//  Copyright © 2019 Kevin Maldjian. All rights reserved.
//

import XCTest

class barterAppTesting: XCTestCase {

    func testFunc() {
        
        var helloString : String?
        
        XCTAssertNil(helloString)
        
        helloString = "hello"
        
        XCTAssertEqual(helloString, "hello")
        
        
    }

}
