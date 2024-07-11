//
//  DataModels.swift
//  Reservation
//
//  Created by Craig Fisher on 7/11/24.
//

import Foundation

struct Provider: Identifiable {
    let id: UUID
    let name: String
    var schedule: [TimeSlot]
}

struct Client: Identifiable {
    let id: UUID
    let name: String
    var reservations: [Reservation]
}

struct TimeSlot: Identifiable, Hashable {
    var id: UUID
    var startTime: Date
    var endTime: Date
    var isReserved: Bool = false

    // Hashable conformance
    static func == (lhs: TimeSlot, rhs: TimeSlot) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Reservation: Identifiable {
    let id: UUID
    let clientID: UUID
    let timeSlotID: UUID
    let reservationTime: Date
    var isConfirmed: Bool = false
}

let mockProviders = [
    Provider(id: UUID(), name: "Dr. Smith", schedule: [
        TimeSlot(id: UUID(), startTime: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!, endTime: Calendar.current.date(byAdding: .minute, value: 15, to: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!)!),
        TimeSlot(id: UUID(), startTime: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!, endTime: Calendar.current.date(byAdding: .minute, value: 15, to: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!)!)
    ]),
    Provider(id: UUID(), name: "Dr. Johnson", schedule: [
        TimeSlot(id: UUID(), startTime: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!, endTime: Calendar.current.date(byAdding: .minute, value: 15, to: Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!)!),
        TimeSlot(id: UUID(), startTime: Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!, endTime: Calendar.current.date(byAdding: .minute, value: 15, to: Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!)!)
    ]),
    Provider(id: UUID(), name: "Dr. Williams", schedule: [
        TimeSlot(id: UUID(), startTime: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!, endTime: Calendar.current.date(byAdding: .minute, value: 15, to: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!)!),
        TimeSlot(id: UUID(), startTime: Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!, endTime: Calendar.current.date(byAdding: .minute, value: 15, to: Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!)!)
    ])
]

let mockClients = [
    Client(id: UUID(), name: "John Doe", reservations: []),
    Client(id: UUID(), name: "Jane Smith", reservations: []),
    Client(id: UUID(), name: "Alice Johnson", reservations: [])
]



