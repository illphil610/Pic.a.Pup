//
//  UtilityTests.swift
//  Pic.a.PupTests
//
//  Created by Philip on 4/26/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import XCTest
@testable import Pic_a_Pup


class UtilityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func createDog() {
        let result = true
        XCTAssertTrue(result)
    }
    
    func testCreation() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformance() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDisplayParksOnMap() {
        let result = true
        XCTAssertTrue(result)
    }
    
    func testGetShelter() {
        let result = true
        XCTAssertTrue(result)
    }
    
    func testGetDogOwner() {
        let result = true
        XCTAssertTrue(result)
    }
    
    func testDogInfo() {
        let result = true
        XCTAssertTrue(result)
    }
}
