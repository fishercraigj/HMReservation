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

    var body: some View {
        NavigationStack {
            VStack {
                Text("Note: Appointments can only be booked 24 hours in advance.")
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding(.bottom, 10)
                
                List {
                    ForEach(groupedSlotsByDate.keys.sorted(), id: \.self) { date in
                        Section(header: Text(dateHeader(for: date))) {
                            ForEach(groupedSlotsByDate[date] ?? []) { slot in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(slot.startTime, formatter: DateFormatter.time) - \(slot.endTime, formatter: DateFormatter.time)")
                                    }
                                    if slot.isReserved {
                                        Text("Reserved")
                                    } else {
                                        let isAvailable = Calendar.current.date(byAdding: .hour, value: 24, to: Date())! <= slot.startTime
                                        Button(isAvailable ? "Reserve" : "Unavailable") {
                                            if isAvailable {
                                                selectedTimeSlot = slot
                                            }
                                        }
                                        .disabled(!isAvailable)
                                        .foregroundColor(isAvailable ? .blue : .gray)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle(provider.name)
                .background(
                    NavigationLink(destination: selectedTimeSlot.map {
                        ReservationConfirmationView(provider: provider, timeSlot: $0, selectedClient: selectedClient, clientVM: clientVM, providerVM: providerVM)
                    }, isActive: .constant(selectedTimeSlot != nil)) {
                        EmptyView()
                    }
                )
            }
            .onAppear {
                selectedTimeSlot = nil
            }
            .background(Color.clear)
        }
    }

    private var groupedSlotsByDate: [String: [TimeSlot]] {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return Dictionary(grouping: providerVM.providers.first(where: { $0.id == provider.id })?.schedule ?? []) {
            formatter.string(from: $0.startTime)
        }
    }

    private func dateHeader(for date: String) -> String {
        return date
    }
}

struct ProviderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let clientVM = ClientViewModel()
        let providerVM = ProviderViewModel()
        let provider = providerVM.providers.first!
        let client = clientVM.clients.first!

        ProviderDetailView(provider: provider, clientVM: clientVM, providerVM: providerVM, selectedClient: client)
    }
}
