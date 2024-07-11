//
//  ProviderViewModel.swift
//  Reservation
//
//  Created by Craig Fisher on 7/11/24.
//

import SwiftUI

class ProviderViewModel: ObservableObject {
    @Published var providers: [Provider] = mockProviders
    
    func addTimeSlot(providerID: UUID, timeSlot: TimeSlot) {
        if let index = providers.firstIndex(where: { $0.id == providerID }) {
            providers[index].schedule.append(timeSlot)
        }
    }
}
