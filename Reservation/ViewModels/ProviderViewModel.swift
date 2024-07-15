//
//  ProviderViewModel.swift
//  Reservation
//
//  Created by Craig Fisher on 7/11/24.
//

import SwiftUI

class ProviderViewModel: ObservableObject {
    @Published var providers: [Provider]

    init() {
        // Create a single time slot for today less than 24 hours from now
        let todayStart = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!
        let todayEnd = Calendar.current.date(byAdding: .minute, value: 15, to: todayStart)!
        let todaySlot = TimeSlot(id: UUID(), startTime: todayStart, endTime: todayEnd)
        
        // Create multiple time slots that are greater than 24 hours out
        var futureSlots: [TimeSlot] = []
        for days in 2...30 {
            for hour in [10, 11, 14, 15] {
                let start = Calendar.current.date(byAdding: .day, value: days, to: Date())!
                let startTime = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: start)!
                let endTime = Calendar.current.date(byAdding: .minute, value: 15, to: startTime)!
                futureSlots.append(TimeSlot(id: UUID(), startTime: startTime, endTime: endTime))
            }
        }

        // Ensure at least two slots are more than 24 hours out
        let availableFutureSlots = futureSlots.filter { Calendar.current.date(byAdding: .hour, value: 24, to: Date())! <= $0.startTime }.prefix(2)

        let slotsForProvider1 = [todaySlot] + Array(availableFutureSlots)
        let slotsForProvider2 = Array(availableFutureSlots)

        self.providers = [
            Provider(id: UUID(), name: "Dr. Smith", schedule: slotsForProvider1),
            Provider(id: UUID(), name: "Dr. Jones", schedule: slotsForProvider2)
        ]
    }

    func reserveTimeSlot(providerID: UUID, timeSlotID: UUID) -> Bool {
        guard let providerIndex = providers.firstIndex(where: { $0.id == providerID }),
              let timeSlotIndex = providers[providerIndex].schedule.firstIndex(where: { $0.id == timeSlotID }) else {
            return false
        }

        let timeSlot = providers[providerIndex].schedule[timeSlotIndex]

        // Check if the reservation is at least 24 hours in advance
        if Calendar.current.date(byAdding: .hour, value: 24, to: Date())! > timeSlot.startTime {
            return false
        }

        // Reserve the slot
        providers[providerIndex].schedule[timeSlotIndex].isReserved = true
        return true
    }

    func confirmReservation(providerID: UUID, timeSlotID: UUID) {
        guard let providerIndex = providers.firstIndex(where: { $0.id == providerID }),
              let slotIndex = providers[providerIndex].schedule.firstIndex(where: { $0.id == timeSlotID }) else {
            return
        }

        providers[providerIndex].schedule[slotIndex].isReserved = true
    }

    func cancelReservation(providerID: UUID, timeSlotID: UUID) {
        guard let providerIndex = providers.firstIndex(where: { $0.id == providerID }),
              let slotIndex = providers[providerIndex].schedule.firstIndex(where: { $0.id == timeSlotID }) else {
            return
        }

        providers[providerIndex].schedule[slotIndex].isReserved = false
    }
}
