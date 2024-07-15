//
//  ClientViewModel.swift
//  Reservation
//
//  Created by Craig Fisher on 7/11/24.
//

import SwiftUI

class ClientViewModel: ObservableObject {
    @Published var clients: [Client]
    @Published var providers: [Provider] = []

    init() {
        self.clients = [
            Client(id: UUID(), name: "John Doe", reservations: []),
            Client(id: UUID(), name: "Jane Smith", reservations: []),
            Client(id: UUID(), name: "Alice Johnson", reservations: [])
        ]
        
        // Create a single time slot for today
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

    func reserveTimeSlot(clientID: UUID, providerID: UUID, timeSlotID: UUID, providers: inout [Provider]) -> Bool {
        guard let clientIndex = clients.firstIndex(where: { $0.id == clientID }),
              let providerIndex = providers.firstIndex(where: { $0.id == providerID }),
              let timeSlotIndex = providers[providerIndex].schedule.firstIndex(where: { $0.id == timeSlotID }) else {
            return false
        }

        let timeSlot = providers[providerIndex].schedule[timeSlotIndex]

        // Check if the reservation is at least 24 hours in advance
        if Calendar.current.date(byAdding: .hour, value: 24, to: Date())! > timeSlot.startTime {
            return false
        }

        // Reserve the slot
        let reservation = Reservation(id: UUID(), timeSlotID: timeSlotID, confirmed: false)
        clients[clientIndex].reservations.append(reservation)
        providers[providerIndex].schedule[timeSlotIndex].isReserved = true
        return true
    }

    func confirmReservation(clientID: UUID, reservationID: UUID, providers: inout [Provider]) {
        guard let clientIndex = clients.firstIndex(where: { $0.id == clientID }),
              let reservationIndex = clients[clientIndex].reservations.firstIndex(where: { $0.id == reservationID }) else {
            return
        }

        clients[clientIndex].reservations[reservationIndex].confirmed = true

        // Update the provider's schedule to mark the slot as confirmed
        let timeSlotID = clients[clientIndex].reservations[reservationIndex].timeSlotID
        for providerIndex in 0..<providers.count {
            if let slotIndex = providers[providerIndex].schedule.firstIndex(where: { $0.id == timeSlotID }) {
                providers[providerIndex].schedule[slotIndex].isReserved = true
                break
            }
        }
    }

    func checkExpiredReservations() {
        let now = Date()
        for i in 0..<clients.count {
            for j in (0..<clients[i].reservations.count).reversed() { // Iterate in reverse to remove expired reservations safely
                if let timeSlot = providers.flatMap({ $0.schedule }).first(where: { $0.id == clients[i].reservations[j].timeSlotID }),
                   !clients[i].reservations[j].confirmed,
                   now > timeSlot.startTime.addingTimeInterval(-30 * 60) {
                    // Reservation has expired
                    clients[i].reservations.remove(at: j)
                }
            }
        }
    }
}
