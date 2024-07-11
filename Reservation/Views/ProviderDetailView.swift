//
//  ReservationConfirmationView.swift
//  Reservation
//
//  Created by Craig Fisher on 7/11/24.
//

import SwiftUI

struct ProviderDetailView: View {
    var provider: Provider
    @ObservedObject var clientVM: ClientViewModel
    @ObservedObject var providerVM: ProviderViewModel
    var selectedClient: Client
    @State private var selectedTimeSlot: TimeSlot?
    @State private var showBanner = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                List(provider.schedule) { slot in
                    HStack {
                        Text("\(slot.startTime, formatter: DateFormatter.time) - \(slot.endTime, formatter: DateFormatter.time)")
                        if slot.isReserved {
                            Text("Reserved")
                        } else {
                            Button("Reserve") {
                                clientVM.reserveTimeSlot(clientID: selectedClient.id, providerID: provider.id, timeSlotID: slot.id, providers: &providerVM.providers)
                                selectedTimeSlot = slot
                            }
                        }
                    }
                }
                .navigationTitle(provider.name)
                .background(
                    NavigationLink(destination: selectedTimeSlot.map {
                        ReservationConfirmationView(provider: provider, timeSlot: $0, selectedClient: selectedClient, clientVM: clientVM, providerVM: providerVM, showBanner: $showBanner)
                    }, isActive: .constant(selectedTimeSlot != nil)) {
                        EmptyView()
                    }
                )
                
                if showBanner {
                    BannerView(message: "Appointment Successfully Booked!", isVisible: $showBanner)
                        .padding(.top, 10)
                }
            }
            .background(Color.clear)
        }
    }
}

struct ProviderDetailView_Previews: PreviewProvider {
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

        ProviderDetailView(provider: mockProviders[0], clientVM: clientVM, providerVM: providerVM, selectedClient: client)
            .environmentObject(clientVM)
    }
}
