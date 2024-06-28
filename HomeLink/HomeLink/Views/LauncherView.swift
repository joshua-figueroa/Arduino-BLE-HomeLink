//
//  LauncherView.swift
//  HomeLink
//
//  Created by Joshua Figueroa on 6/28/24.
//

import SwiftUI

struct LauncherView: View {
    @ObservedObject var bleManager: BLEManager
    @Binding var getStarted: Bool

    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 5) {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("Arduino BLE")
                    .foregroundColor(.primary)
                Text("HomeLink")
                    .foregroundColor(.primary)
            }
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.vertical, 15)
            
            Text("Welcome to BLE HomeLink! This app connects to your Arduino BLE device to provide seamless wireless communication.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 30)
            
            Spacer()
            
            Button(action: {
                getStarted = true
                bleManager.startScanning()
            }) {
                Text("Get Started")
                    .font(.title2)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.bottom, 30)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemBackground), Color("Background")]), startPoint: .top, endPoint: .bottom)
        )
        .ignoresSafeArea(.container, edges: .all)
    }
}

#Preview {
    LauncherView(bleManager: MockBLEManager(isConnected: true), getStarted: .constant(false))
}
