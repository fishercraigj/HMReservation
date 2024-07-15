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

    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 20) {
            // Left-justified Title
            Text("Appointment Confirmation")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .accessibility(addTraits: .isHeader)

            // Reservation Details Cell
            VStack(alignment: .leading, spacing: 10) {
                Text("Provider: \(provider.name)")
                    .font(.headline)
                    .accessibility(label: Text("Provider"))
                    .accessibility(value: Text(provider.name))
                Text("Client: \(selectedClient.name)")
                    .font(.subheadline)
                    .accessibility(label: Text("Client"))
                    .accessibility(value: Text(selectedClient.name))
                Text("Date: \(timeSlot.startTime.customDateString())")
                    .font(.subheadline)
                    .accessibility(label: Text("Date"))
                    .accessibility(value: Text(timeSlot.startTime.customDateString()))
                Text("Time: \(timeSlot.startTime.customTimeString()) - \(timeSlot.endTime.customTimeString()) \(timeSlot.startTime.timeZoneAbbreviation() ?? "")")
                    .font(.subheadline)
                    .accessibility(label: Text("Time"))
                    .accessibility(value: Text("\(timeSlot.startTime.customTimeString()) to \(timeSlot.endTime.customTimeString()) \(timeSlot.startTime.timeZoneAbbreviation() ?? "")"))
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
            .shadow(radius: 5)
            .accessibilityElement(children: .combine)

            Spacer()

            // Confirm Button
            Button(action: {
                let reservationID = UUID() // Generate a new reservation ID
                clientVM.confirmReservation(clientID: selectedClient.id, reservationID: reservationID, providers: &providerVM.providers)
                providerVM.reserveTimeSlot(providerID: provider.id, timeSlotID: timeSlot.id)
                showAlert = true
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Confirm Reservation")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .accessibility(label: Text("Confirm Reservation"))
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Reservation Confirmed"),
                    message: Text("Your reservation with \(provider.name) has been confirmed."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
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
