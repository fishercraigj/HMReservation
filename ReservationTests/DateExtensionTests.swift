//
//  DateExtensionTests.swift
//  ReservationTests
//
//  Created by Craig Fisher on 7/15/24.
//

import XCTest
@testable import Reservation

class DateExtensionTests: XCTestCase {

    func testTimeFormatter() {
        let formatter = DateFormatter.time
        let date = Date(timeIntervalSince1970: 0) // Jan 1, 1970, 00:00:00 UTC
        let formattedTime = formatter.string(from: date)
        
        // Get the expected formatted time string based on the current locale and settings
        let referenceFormatter = DateFormatter()
        referenceFormatter.timeStyle = .short
        let expectedFormattedTime = referenceFormatter.string(from: date)
        
        XCTAssertEqual(formattedTime, expectedFormattedTime, "The time formatter did not produce the expected string")
    }

    func testCustomDateFormatter() {
        let formatter = DateFormatter.customDate
        let date = Date(timeIntervalSince1970: 0) // Jan 1, 1970
        let formattedDate = formatter.string(from: date)
        XCTAssertEqual(formattedDate, "12/31/69", "The custom date formatter did not produce the expected string")
    }

    func testCustomTimeFormatter() {
        let formatter = DateFormatter.customTime
        let date = Date(timeIntervalSince1970: 0) // Jan 1, 1970, 00:00:00 UTC
        let formattedTime = formatter.string(from: date)
        
        // Get the expected formatted time string based on the current locale and settings
        let referenceFormatter = DateFormatter()
        referenceFormatter.dateFormat = "h:mm a"
        let expectedFormattedTime = referenceFormatter.string(from: date)
        
        XCTAssertEqual(formattedTime, expectedFormattedTime, "The custom time formatter did not produce the expected string")
    }

    func testTimeZoneAbbreviation() {
        let date = Date()
        let timeZoneAbbreviation = date.timeZoneAbbreviation()
        let expectedTimeZoneAbbreviation = TimeZone.current.abbreviation()
        XCTAssertEqual(timeZoneAbbreviation, expectedTimeZoneAbbreviation, "The time zone abbreviation did not match the expected value")
    }
}

