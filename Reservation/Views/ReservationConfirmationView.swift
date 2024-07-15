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
            Text("Confirm Reservation")
                .font(.headline)
                .padding()

            Text("Provider: \(provider.name)")
            Text("Client: \(selectedClient.name)")
            Text("Date: \(timeSlot.startTime.customDateString())")
            Text("Time: \(timeSlot.startTime.customTimeString()) - \(timeSlot.endTime.customTimeString()) \(timeSlot.startTime.timeZoneAbbreviation() ?? "")")

            Button("Confirm") {
                let reservationID = UUID() // Generate a new reservation ID
                clientVM.confirmReservation(clientID: selectedClient.id, reservationID: reservationID, providers: &providerVM.providers)
                providerVM.reserveTimeSlot(providerID: provider.id, timeSlotID: timeSlot.id)
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .navigationTitle("Reservation Confirmation")
        .padding()
    }
}

struct ReservationConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        let clientVM = ClientViewModel()
        let providerVM = ProviderViewModel()
        let provider = providerVM.providers.first!
        let client = clientVM.clients.first!
        let timeSlot = provider.schedule.first!

        ReservationConfirmationView(provider: provider, timeSlot: timeSlot, selectedClient: client, clientVM: clientVM, providerVM: providerVM)
    }
}
