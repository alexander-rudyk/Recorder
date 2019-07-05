//
//  Genesis_TestTests.swift
//  Genesis_TestTests
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import XCTest
@testable import Genesis_Test

class Genesis_TestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        XCTAssertTrue(true)
    }
    
    func testFail() {
        XCTAssertTrue(false, "Fail test")
    }
}
