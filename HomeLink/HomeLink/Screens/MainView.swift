//
//  MainView.swift
//  HomeLink
//
//  Created by Joshua Figueroa on 6/19/24.
//

import SwiftUI

struct MainView: View {
    @AppStorage("getStarted") var getStarted: Bool = false
    @ObservedObject var bleManager: BLEManager
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            VStack {
                Text("Arduino BLE")
                Text("HomeLink")
            }
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.vertical, 20)
            
            Text("Welcome to BLE HomeLink! This app connects to your Arduino BLE device to provide seamless wireless communication.")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 30)

            Spacer()
            
            if bleManager.deviceState == .poweredOn {
                if bleManager.isConnected {
                    Text("Connected to ArduinoLink")
                        .font(.title)
                        .foregroundColor(.green)
                    
                    Text("RSSI: \(bleManager.rssi) dBm")
                        .font(.title)
                        .padding(.top, 20)
                    
                    Text("Temperature: \(bleManager.temperature) °C")
                        .font(.title)
                        .padding(.top, 20)
                    
                    Text("Humidity: \(bleManager.humidity) %")
                        .font(.title)
                        .padding(.top, 20)
                } else {
                    LoaderView()
                }
            }
            
            Spacer()
            
            if !getStarted {
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
                }
                .padding()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Bluetooth Permission"),
                message: Text("Bluetooth permissions are denied. Please enable permissions in settings."),
                primaryButton: .default(Text("Settings"), action: {
                    openSettings()
                }),
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
        .onAppear() {
            if getStarted {
                bleManager.startScanning()
            }
        }
        .onChange(of: bleManager.deviceState) { state in
            if state == .unauthorized {
                showAlert = true
            }
        }
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

#Preview("Connected") {
    MainView(bleManager: MockBLEManager(isConnected: true))
}

#Preview("Disconnected") {
    MainView(bleManager: MockBLEManager(isConnected: false))
}
