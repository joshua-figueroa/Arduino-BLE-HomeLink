//
//  ContentView.swift
//  WatchHomeLink Watch App
//
//  Created by Joshua Figueroa on 6/29/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var watchManager = PhoneSessionManager.shared

    var body: some View {
        VStack {
            if watchManager.getStarted && watchManager.sessionActive {
                DataView(watchManager: watchManager)
            } else {
                LauncherView()
            }
        }
    }
}

#Preview("Launcher View") {
    ContentView(watchManager: MockWatchSession(isConnected: true, getStarted: false))
}

#Preview("Data View") {
    ContentView(watchManager: MockWatchSession(isConnected: true))
}
