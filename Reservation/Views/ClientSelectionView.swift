//
//  ContentView.swift
//  Reservation
//
//  Created by Craig Fisher on 7/11/24.
//

import SwiftUI

struct ClientSelectionView: View {
    @StateObject var clientVM = ClientViewModel()
    @State private var selectedClient: Client?

    var body: some View {
        NavigationStack {
            List(clientVM.clients) { client in
                NavigationLink(destination: ProviderListView(selectedClient: client)) {
                    Text(client.name)
                        .accessibility(label: Text("Client Name"))
                        .accessibility(value: Text(client.name))
                }
            }
            .navigationTitle("Select a Client")
            .accessibility(label: Text("Client List"))
        }
    }
}

struct ClientSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ClientSelectionView()
    }
}
