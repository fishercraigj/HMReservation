//
//  Extension+Date.swift
//  Reservation
//
//  Created by Craig Fisher on 7/11/24.
//

import Foundation

extension DateFormatter {
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    static let customDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    
    static let customTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
}

extension Date {
    func customDateString() -> String {
        return DateFormatter.customDate.string(from: self)
    }
    
    func customTimeString() -> String {
        return DateFormatter.customTime.string(from: self)
    }
    
    func timeZoneAbbreviation() -> String? {
        let timeZone = TimeZone.current
        return timeZone.abbreviation()
    }
}
