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
        List(clientVM.clients) { client in
            NavigationLink(destination: ProviderListView(selectedClient: client)) {
                Text(client.name)
            }
        }
        .navigationTitle("Select a Client")
    }
}

struct ClientSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ClientSelectionView()
    }
}
