//
//  ReservationConfirmationView.swift
//  Reservation
//
//  Created by Craig Fisher on 7/11/24.
//

import SwiftUI

struct ReservationConfirmationView: View {
    var provider: Provider
    var timeSlot: TimeSlot
    var selectedClient: Client
    @ObservedObject var clientVM: ClientViewModel
    @ObservedObject var providerVM: ProviderViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Provider: \(provider.name)")
            Text("Time Slot: \(timeSlot.startTime, formatter: DateFormatter.time) - \(timeSlot.endTime, formatter: DateFormatter.time)")
            Button("Confirm Reservation") {
                if let reservation = clientVM.clients.first(where: { $0.id == selectedClient.id })?.reservations.first(where: { $0.timeSlotID == timeSlot.id }) {
                    clientVM.confirmReservation(clientID: selectedClient.id, reservationID: reservation.id, providers: &providerVM.providers)
                    presentationMode.wrappedValue.dismiss() // Navigate back to the previous view
                }
            }
        }
        .navigationTitle("Confirm Reservation")
        .onAppear {
            clientVM.checkExpiredReservations()
        }
    }
}

struct ReservationConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        let mockProviders = [
            Provider(id: UUID(), name: "Dr. Smith", schedule: [
                TimeSlot(id: UUID(), startTime: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!, endTime: Calendar.current.date(byAdding: .minute, value: 15, to: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!)!),
                TimeSlot(id: UUID(), startTime: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!, endTime: Calendar.current.date(byAdding: .minute, value: 15, to: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!)!)
            ])
        ]
        let clientVM = ClientViewModel()
        let providerVM = ProviderViewModel()
        let client = Client(id: UUID(), name: "John Doe", reservations: [])
        let timeSlot = mockProviders[0].schedule[0]

        NavigationStack {
            ReservationConfirmationView(provider: mockProviders[0], timeSlot: timeSlot, selectedClient: client, clientVM: clientVM, providerVM: providerVM)
                .environmentObject(clientVM)
        }
    }
}
