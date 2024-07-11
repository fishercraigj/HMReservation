//
//  SuccessView.swift
//  Reservation
//
//  Created by Craig Fisher on 7/11/24.
//

import SwiftUI

struct BannerView: View {
    var message: String
    var duration: Double = 3.0
    
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack {
            if isVisible {
                Text(message)
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                isVisible = false
                            }
                        }
                    }
            }
        }
        .animation(.easeInOut, value: isVisible)
    }
}
