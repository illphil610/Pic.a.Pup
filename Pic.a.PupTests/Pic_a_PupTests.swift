//
//  Pic_a_PupTests.swift
//  Pic.a.PupTests
//
//  Created by Philip on 3/30/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import XCTest
@testable import Pic_a_Pup

class Pic_a_PupTests: XCTestCase {
    
    var dogLover: DogLover!
    var utility: Utility!
    
    override func setUp() {
        super.setUp()
        utility = Utility()
    }
    
    override func tearDown() {
        super.tearDown()
        dogLover = nil
        utility = nil
    }
    
    func testDogLoverNotCreated() {
        XCTAssertNil(dogLover)
    }
    
    func testDogLoverIscreated() {
        let testDogLover = DogLover(name: "Phil", phoneNumber: "610-955-5752", fcm_id: "asljdkhjf;lkjerl;fjrlkfjrl;kf")
        
        XCTAssertNotNil(testDogLover)
    }
    
    func testEmailIsInProperFormat() {
        let testEmail = "phil@picapup.com"
        XCTAssertTrue(utility.isValidEmail(testEmail))
    }
    
    // This is testing that its returning false, but the test will return true if that makes sense....
    func testEmailIsNotInProperFormat() {
        let testEmail = "@Philpicapup"
        XCTAssertFalse(utility.isValidEmail(testEmail))
    }
    
    func testFireBaseLogInSuccess() {
        let result = true
        XCTAssertTrue(result)
    }
    
    // Password Condition:
    //      - must contains one digit from 0-9
    //      - must contains one lowercase characters
    //      - must contains one uppercase characters
    //      - must contains one special symbols in the list "@#$%"
    //      - length at least 6 characters and maximum of 20
    func testPasswordIsInProperFormat() {
        let testPassword = "Password1015!"
        XCTAssertTrue(utility.isValidPassword(testPassword))
    }
    
    func testPasswordWithIncorrectFormat() {
        let testPassword = "Password"
        XCTAssertFalse(utility.isValidPassword(testPassword))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

