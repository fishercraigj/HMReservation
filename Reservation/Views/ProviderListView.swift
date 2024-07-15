//
//  ProviderListView.swift
//  Reservation
//
//  Created by Craig Fisher on 7/11/24.
//

import SwiftUI

struct ProviderListView: View {
    var selectedClient: Client
    @StateObject var providerVM = ProviderViewModel()
    @StateObject var clientVM = ClientViewModel()

    var body: some View {
        List(providerVM.providers) { provider in
            NavigationLink(destination: ProviderDetailView(provider: provider, clientVM: clientVM, providerVM: providerVM, selectedClient: selectedClient)) {
                Text(provider.name)
                    .accessibility(label: Text("Provider Name"))
                    .accessibility(value: Text(provider.name))
            }
        }
        .navigationTitle("Select a Provider")
        .accessibility(label: Text("Provider List"))
    }
}

struct ProviderListView_Previews: PreviewProvider {
    static var previews: some View {
        let client = Client(id: UUID(), name: "John Doe", reservations: [])
        ProviderListView(selectedClient: client)
    }
}
