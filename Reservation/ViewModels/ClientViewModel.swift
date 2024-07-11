//
//  ClientViewModel.swift
//  Reservation
//
//  Created by Craig Fisher on 7/11/24.
//
import SwiftUI

class ClientViewModel: ObservableObject {
    @Published var clients: [Client] = mockClients

    func reserveTimeSlot(clientID: UUID, providerID: UUID, timeSlotID: UUID, providers: inout [Provider]) {
        if let providerIndex = providers.firstIndex(where: { $0.id == providerID }),
           let timeSlotIndex = providers[providerIndex].schedule.firstIndex(where: { $0.id == timeSlotID }) {
            providers[providerIndex].schedule[timeSlotIndex].isReserved = true

            let reservation = Reservation(id: UUID(), clientID: clientID, timeSlotID: timeSlotID, reservationTime: Date())
            if let clientIndex = clients.firstIndex(where: { $0.id == clientID }) {
                clients[clientIndex].reservations.append(reservation)
            }
        }
    }

    func confirmReservation(clientID: UUID, reservationID: UUID, providers: inout [Provider]) {
        if let clientIndex = clients.firstIndex(where: { $0.id == clientID }),
           let reservationIndex = clients[clientIndex].reservations.firstIndex(where: { $0.id == reservationID }) {
            clients[clientIndex].reservations[reservationIndex].isConfirmed = true
            removeReservedSlot(providerID: clients[clientIndex].reservations[reservationIndex].timeSlotID, providers: &providers)
        }
    }

    func removeReservedSlot(providerID: UUID, providers: inout [Provider]) {
        if let providerIndex = providers.firstIndex(where: { $0.id == providerID }) {
            providers[providerIndex].schedule.removeAll { $0.isReserved }
        }
    }

    func checkExpiredReservations() {
        for client in clients {
            for reservation in client.reservations {
                if !reservation.isConfirmed && Date().timeIntervalSince(reservation.reservationTime) > 1800 {
                    if let clientIndex = clients.firstIndex(where: { $0.id == client.id }),
                       let reservationIndex = clients[clientIndex].reservations.firstIndex(where: { $0.id == reservation.id }) {
                        clients[clientIndex].reservations.remove(at: reservationIndex)
                    }
                }
            }
        }
    }
}
