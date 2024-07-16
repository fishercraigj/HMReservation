//
//  ReservationTests.swift
//  ReservationTests
//
//  Created by Craig Fisher on 7/11/24.
//

import XCTest
@testable import Reservation

class ClientViewModelTests: XCTestCase {

    var clientVM: ClientViewModel!
    var provider: Provider!
    var client: Client!
    var timeSlot: TimeSlot!
    var futureTimeSlot: TimeSlot!

    override func setUp() {
        super.setUp()
        clientVM = ClientViewModel()
        provider = clientVM.providers.first!
        client = clientVM.clients.first!
        timeSlot = provider.schedule.first! // Less than 24 hours from now
        futureTimeSlot = provider.schedule.last! // Greater than 24 hours from now
    }

    override func tearDown() {
        clientVM = nil
        provider = nil
        client = nil
        timeSlot = nil
        futureTimeSlot = nil
        super.tearDown()
    }

    func testReserveTimeSlotSuccess() {
        var providers = clientVM.providers
        let success = clientVM.reserveTimeSlot(clientID: client.id, providerID: provider.id, timeSlotID: futureTimeSlot.id, providers: &providers)
        XCTAssertTrue(success, "Failed to reserve a future time slot")
        XCTAssertTrue(providers.first!.schedule.first { $0.id == futureTimeSlot.id }!.isReserved, "Future time slot is not marked as reserved")
    }

    func testReserveTimeSlotFailureLessThan24Hours() {
        var providers = clientVM.providers
        let success = clientVM.reserveTimeSlot(clientID: client.id, providerID: provider.id, timeSlotID: timeSlot.id, providers: &providers)
        XCTAssertFalse(success, "Reserved a time slot less than 24 hours from now")
        XCTAssertFalse(providers.first!.schedule.first { $0.id == timeSlot.id }!.isReserved, "Time slot less than 24 hours is marked as reserved")
    }

    func testConfirmReservation() {
        var providers = clientVM.providers
        // First, reserve the time slot to create a reservation
        let reserveSuccess = clientVM.reserveTimeSlot(clientID: client.id, providerID: provider.id, timeSlotID: futureTimeSlot.id, providers: &providers)
        XCTAssertTrue(reserveSuccess, "Failed to reserve the time slot for confirmation test")

        guard let reservation = clientVM.clients.first!.reservations.first(where: { $0.timeSlotID == futureTimeSlot.id }) else {
            XCTFail("Reservation not found")
            return
        }

        // Confirm the reservation
        clientVM.confirmReservation(clientID: client.id, reservationID: reservation.id, providers: &providers)
        XCTAssertTrue(clientVM.clients.first!.reservations.first { $0.id == reservation.id }!.confirmed, "Reservation is not marked as confirmed")
        XCTAssertTrue(providers.first!.schedule.first { $0.id == futureTimeSlot.id }!.isReserved, "Time slot is not marked as reserved after confirmation")
    }

    func testCheckExpiredReservations() {
        // Ensure the clientVM's providers are used in the method
        let expiredSlot = TimeSlot(id: UUID(), startTime: Date().addingTimeInterval(-3600), endTime: Date().addingTimeInterval(-3540))
        clientVM.providers[0].schedule.append(expiredSlot)
        clientVM.clients[0].reservations.append(Reservation(id: UUID(), timeSlotID: expiredSlot.id, confirmed: false))

        clientVM.checkExpiredReservations()

        XCTAssertFalse(clientVM.clients[0].reservations.contains { $0.timeSlotID == expiredSlot.id }, "Expired reservation is not removed")
    }
}

