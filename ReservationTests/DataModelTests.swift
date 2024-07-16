//
//  DataModelTests.swift
//  ReservationTests
//
//  Created by Craig Fisher on 7/15/24.
//

import XCTest
@testable import Reservation

class DataModelTests: XCTestCase {

    func testProviderEquality() {
        let provider1 = Provider(id: UUID(), name: "Dr. Smith", schedule: [])
        let provider2 = Provider(id: provider1.id, name: "Dr. Smith", schedule: [])
        let provider3 = Provider(id: UUID(), name: "Dr. Jones", schedule: [])

        XCTAssertEqual(provider1, provider2, "Providers with the same ID should be equal")
        XCTAssertNotEqual(provider1, provider3, "Providers with different IDs should not be equal")
    }

    func testProviderHashable() {
        let provider1 = Provider(id: UUID(), name: "Dr. Smith", schedule: [])
        let provider2 = Provider(id: provider1.id, name: "Dr. Smith", schedule: [])

        var set = Set<Provider>()
        set.insert(provider1)
        set.insert(provider2)

        XCTAssertEqual(set.count, 1, "Hashable should ensure no duplicates in the set for the same provider ID")
    }

    func testTimeSlotEquality() {
        let timeSlot1 = TimeSlot(id: UUID(), startTime: Date(), endTime: Date().addingTimeInterval(900))
        let timeSlot2 = TimeSlot(id: timeSlot1.id, startTime: Date(), endTime: Date().addingTimeInterval(900))
        let timeSlot3 = TimeSlot(id: UUID(), startTime: Date(), endTime: Date().addingTimeInterval(900))

        XCTAssertEqual(timeSlot1, timeSlot2, "TimeSlots with the same ID should be equal")
        XCTAssertNotEqual(timeSlot1, timeSlot3, "TimeSlots with different IDs should not be equal")
    }

    func testTimeSlotHashable() {
        let timeSlot1 = TimeSlot(id: UUID(), startTime: Date(), endTime: Date().addingTimeInterval(900))
        let timeSlot2 = TimeSlot(id: timeSlot1.id, startTime: Date(), endTime: Date().addingTimeInterval(900))

        var set = Set<TimeSlot>()
        set.insert(timeSlot1)
        set.insert(timeSlot2)

        XCTAssertEqual(set.count, 1, "Hashable should ensure no duplicates in the set for the same timeSlot ID")
    }

    func testClientEquality() {
        let client1 = Client(id: UUID(), name: "John Doe", reservations: [])
        let client2 = Client(id: client1.id, name: "John Doe", reservations: [])
        let client3 = Client(id: UUID(), name: "Jane Doe", reservations: [])

        XCTAssertEqual(client1, client2, "Clients with the same ID should be equal")
        XCTAssertNotEqual(client1, client3, "Clients with different IDs should not be equal")
    }

    func testClientHashable() {
        let client1 = Client(id: UUID(), name: "John Doe", reservations: [])
        let client2 = Client(id: client1.id, name: "John Doe", reservations: [])

        var set = Set<Client>()
        set.insert(client1)
        set.insert(client2)

        XCTAssertEqual(set.count, 1, "Hashable should ensure no duplicates in the set for the same client ID")
    }

    func testReservationEquality() {
        let reservation1 = Reservation(id: UUID(), timeSlotID: UUID(), confirmed: false)
        let reservation2 = Reservation(id: reservation1.id, timeSlotID: reservation1.timeSlotID, confirmed: false)
        let reservation3 = Reservation(id: UUID(), timeSlotID: UUID(), confirmed: false)

        XCTAssertEqual(reservation1, reservation2, "Reservations with the same ID should be equal")
        XCTAssertNotEqual(reservation1, reservation3, "Reservations with different IDs should not be equal")
    }

    func testReservationHashable() {
        let reservation1 = Reservation(id: UUID(), timeSlotID: UUID(), confirmed: false)
        let reservation2 = Reservation(id: reservation1.id, timeSlotID: reservation1.timeSlotID, confirmed: false)

        var set = Set<Reservation>()
        set.insert(reservation1)
        set.insert(reservation2)

        XCTAssertEqual(set.count, 1, "Hashable should ensure no duplicates in the set for the same reservation ID")
    }
}
