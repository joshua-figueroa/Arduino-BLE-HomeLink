//
//  DataView.swift
//  HomeLink
//
//  Created by Joshua Figueroa on 6/28/24.
//

import SwiftUI

struct DataView: View {
    @ObservedObject var bleManager: BLEManager
    @State private var showAlert = false
    let getStarted: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack(spacing: 5) {
                    Text("Arduino BLE")
                        .foregroundColor(.primary)
                    Text("HomeLink")
                        .foregroundColor(.primary)
                }
                .font(.largeTitle)
                .fontWeight(.bold)
                
                Spacer()
                
                if bleManager.deviceState == .poweredOn && getStarted {
                    if bleManager.isConnected {
                        let cardWidth = geometry.size.width / 2 - 60
                        
                        VStack(spacing: 20) {
                            Text("Sensor Data")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding(.top, 10)
                            
                            HStack(spacing: 20) {
                                let temp = bleManager.temperature
                                let humid = bleManager.humidity
                                
                                CardView(image: "thermometer", title: "Temperature", content: "\(temp.data)°C", imageColor: .red, loading: temp.fetching, width: cardWidth)
                                
                                CardView(image: "humidity.fill", title: "Humidity", content: "\(humid.data)%", imageColor: .blue, loading: humid.fetching, width: cardWidth)
                            }
                            
                            HStack(spacing: 20) {
                                let air = bleManager.airQuality
                                
                                CardView(image: "leaf.fill", title: "Air Quality", content: "\(Int(air.data)) AQI", imageColor: .green, loading: air.fetching, width: cardWidth)
                            }
                            
                            Text("Last Updated: \(Date(), formatter: Self.dateFormatter)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding(.top, 10)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        SignalStrengthView(signalStrength: bleManager.signalStrength)
                            .padding(.bottom, 20)
                    } else {
                        LoaderView()
                        Spacer()
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemBackground), Color("Background")]), startPoint: .top, endPoint: .bottom)
        )
        .ignoresSafeArea(.container, edges: [.horizontal, .bottom])
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
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }
}

#Preview("Connected") {
    DataView(bleManager: MockBLEManager(isConnected: true), getStarted: true)
    
}

#Preview("Disconnected") {
    DataView(bleManager: MockBLEManager(isConnected: false), getStarted: true)
}
