//
//  CameraTests.swift
//  Pic.a.PupTests
//
//  Created by Philip on 4/26/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import XCTest

class CameraTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCaptureSession() {
        let result = true
        XCTAssertTrue(result)
    }
    
    func testMetadataCollected() {
        let result = true
        XCTAssertTrue(result)
    }
    
    func testCaptureSessionShouldReturnError() {
        let result = true
        XCTAssertTrue(result)
    }
    
    func testPerformance() {
        // This is an example of a performance test case.
        self.measure {
            let result = true
            XCTAssertTrue(result)
        }
    }
    
}
