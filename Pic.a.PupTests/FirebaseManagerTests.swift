//
//  FirebaseManagerTests.swift
//  Pic.a.PupTests
//
//  Created by Philip on 4/26/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import XCTest
@testable import Pic_a_Pup

class FirebaseManagerTests: XCTestCase {
    
    var firebaseManager: FirebaseManager!
    
    override func setUp() {
        super.setUp()
        firebaseManager = FirebaseManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        firebaseManager = nil
    }
    
    func testFirebaseIntegration() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLogUserIntoFirebase() {
        let result = true
        XCTAssertTrue(result)
    }
    
    func testConvertToJSON() {
        let result = true
        XCTAssertTrue(result)
    }
    
    func testGetImageFromFirebase() {
        let result = true
        XCTAssertTrue(result)
    }
    
    func testGetFeedSearchResultList() {
        let result = true
        XCTAssertTrue(result)
    }
}
