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
        self.providers = [
            Provider(id: UUID(), name: "Dr. Smith", schedule: [
                TimeSlot(id: UUID(), startTime: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!,
                         endTime: Calendar.current.date(byAdding: .minute, value: 15, to: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!)!),
                TimeSlot(id: UUID(), startTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!,
                         endTime: Calendar.current.date(byAdding: .minute, value: 15, to: Calendar.current.date(byAdding: .hour, value: 2, to: Date())!)!),
                TimeSlot(id: UUID(), startTime: Calendar.current.date(byAdding: .day, value: 30, to: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!)!,
                         endTime: Calendar.current.date(byAdding: .minute, value: 15, to: Calendar.current.date(byAdding: .day, value: 30, to: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!)!)!)
            ])
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
