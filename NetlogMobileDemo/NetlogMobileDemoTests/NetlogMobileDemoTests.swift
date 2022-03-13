//
// NetlogMobileDemoTests.swift
// NetlogMobileDemoTests
//
// Created on 13.03.2022.
// Oguzhan Yalcin
//
//
//


import XCTest
@testable import NetlogMobileDemo
import GoogleMaps

class NetlogMobileDemoTests: XCTestCase {
    
    func testHandleFormattedDate() {
        let date = "2012-10-26T05:20:05Z".toDate()
        let dateString = date.toString(formatType: "dd-MM-yyyy")
        
        XCTAssertEqual(dateString, "26-10-2012")
    }
    
    func testHandleReplacedText() {
        let text = "No  Need  Empty  Spaces"
        let replacedText = text.replace(string: " ", replacement: "")
        
        XCTAssertEqual(replacedText, "NoNeedEmptySpaces")
    }
    
    func testRequestGeoCodingAPI() {
        let request:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(-33.86), longitude: Double(151.20))
        ServiceManager.shared.getAddressDetail(coordinate: request) { (response, errorCode, isOK) in
            XCTAssertTrue(isOK)
            XCTAssertNotNil(response) //has error response
        }
    }
}
