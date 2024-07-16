//
//  ProviderViewModelTests.swift
//  ReservationTests
//
//  Created by Craig Fisher on 7/15/24.
//

import XCTest
@testable import Reservation

class ProviderViewModelTests: XCTestCase {

    var providerVM: ProviderViewModel!
    var provider: Provider!
    var timeSlot: TimeSlot!
    var futureTimeSlot: TimeSlot!

    override func setUp() {
        super.setUp()
        providerVM = ProviderViewModel()
        provider = providerVM.providers.first!
        timeSlot = provider.schedule.first! // Less than 24 hours from now
        futureTimeSlot = provider.schedule.last! // Greater than 24 hours from now
    }

    override func tearDown() {
        providerVM = nil
        provider = nil
        timeSlot = nil
        futureTimeSlot = nil
        super.tearDown()
    }

    func testReserveTimeSlotSuccess() {
        let success = providerVM.reserveTimeSlot(providerID: provider.id, timeSlotID: futureTimeSlot.id)
        XCTAssertTrue(success, "Failed to reserve a future time slot")
        XCTAssertTrue(providerVM.providers.first!.schedule.first { $0.id == futureTimeSlot.id }!.isReserved, "Future time slot is not marked as reserved")
    }

    func testReserveTimeSlotFailureLessThan24Hours() {
        let success = providerVM.reserveTimeSlot(providerID: provider.id, timeSlotID: timeSlot.id)
        XCTAssertFalse(success, "Reserved a time slot less than 24 hours from now")
        XCTAssertFalse(providerVM.providers.first!.schedule.first { $0.id == timeSlot.id }!.isReserved, "Time slot less than 24 hours is marked as reserved")
    }

    func testConfirmReservation() {
        providerVM.confirmReservation(providerID: provider.id, timeSlotID: futureTimeSlot.id)
        XCTAssertTrue(providerVM.providers.first!.schedule.first { $0.id == futureTimeSlot.id }!.isReserved, "Time slot is not marked as reserved after confirmation")
    }

    func testCancelReservation() {
        providerVM.confirmReservation(providerID: provider.id, timeSlotID: futureTimeSlot.id)
        providerVM.cancelReservation(providerID: provider.id, timeSlotID: futureTimeSlot.id)
        XCTAssertFalse(providerVM.providers.first!.schedule.first { $0.id == futureTimeSlot.id }!.isReserved, "Time slot is not marked as available after cancellation")
    }
}
