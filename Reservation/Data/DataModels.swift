//
//  DataModels.swift
//  Reservation
//
//  Created by Craig Fisher on 7/11/24.
//

import Foundation

struct Provider: Identifiable, Hashable {
    var id: UUID
    var name: String
    var schedule: [TimeSlot]

    static func == (lhs: Provider, rhs: Provider) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct TimeSlot: Identifiable, Hashable {
    var id: UUID
    var startTime: Date
    var endTime: Date
    var isReserved: Bool = false

    static func == (lhs: TimeSlot, rhs: TimeSlot) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Client: Identifiable, Hashable {
    var id: UUID
    var name: String
    var reservations: [Reservation]

    static func == (lhs: Client, rhs: Client) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Reservation: Identifiable, Hashable {
    var id: UUID
    var timeSlotID: UUID
    var confirmed: Bool = false

    static func == (lhs: Reservation, rhs: Reservation) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
