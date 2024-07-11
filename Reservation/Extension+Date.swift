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
}
