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
            .padding(.top, 15)
            
            if !bleManager.isConnected || !getStarted {
                Text("Welcome to BLE HomeLink! This app connects to your Arduino BLE device to provide seamless wireless communication.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }
            
            if bleManager.deviceState == .poweredOn {
                Spacer()
                
                if bleManager.isConnected {
                    Text("Connected to ArduinoLink")
                        .font(.title)
                        .foregroundColor(.green)
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            let temp = bleManager.temperature
                            let humid = bleManager.humidity
                            
                            CardView(image: "thermometer", title: "Temperature", content: "\(temp.data)°C", imageColor: .red, loading: temp.fetching)
                            
                            CardView(image: "humidity.fill", title: "Humidity", content: "\(humid.data)%", imageColor: .blue, loading: humid.fetching)
                        }
                        
                        HStack(spacing: 20) {
                            let air = bleManager.airQuality
                            
                            CardView(image: "leaf.fill", title: "Air Quality", content: "\(Int(air.data)) AQI", imageColor: .green, loading: air.fetching)
                        }
                    }
                    
                    Spacer()
                    SignalStrengthView(signalStrength: bleManager.signalStrength)
                } else {
                    LoaderView()
                    Spacer()
                }
            }
            
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
