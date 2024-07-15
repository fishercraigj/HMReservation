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

    func reserveTimeSlot(providerID: UUID, timeSlotID: UUID) {
        if let providerIndex = providers.firstIndex(where: { $0.id == providerID }),
           let slotIndex = providers[providerIndex].schedule.firstIndex(where: { $0.id == timeSlotID }) {
            providers[providerIndex].schedule[slotIndex].isReserved = true
        }
    }
}

