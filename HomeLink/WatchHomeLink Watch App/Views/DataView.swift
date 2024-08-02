//
//  DataView.swift
//  WatchHomeLink Watch App
//
//  Created by Joshua Figueroa on 7/1/24.
//

import SwiftUI

struct DataView: View {
    @ObservedObject var watchManager: PhoneSessionManager

    var body: some View {
        VStack {
            if watchManager.isConnected {
                List {
                    Section {
                        TitleView()
                    }
                    .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Section {
                        CardView(image: "thermometer", title: "Temperature", content: "\(watchManager.temperature)°C", imageColor: .red)
                        CardView(image: "humidity.fill", title: "Humidity", content: "\(watchManager.humidity)%", imageColor: .blue)
                            
                        CardView(image: "leaf.fill", title: "Air Quality", content: "\(Int(watchManager.airQuality)) AQI", imageColor: .green)
                    }
                    
                    Section {
                        HStack(alignment: .bottom, spacing: 10) {
                            Text("Device Signal:")
                            SignalView(strength: watchManager.signalStrength)
                        }
                    }
                    .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.bottom, 10)
            } else {
                TitleView()
                LoaderView()
                    .padding(.top, 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: .all)
    }
}

#Preview("Connected") {
    DataView(watchManager: MockWatchSession(isConnected: true))
}

#Preview("Connecting") {
    DataView(watchManager: MockWatchSession(isConnected: false))
}
