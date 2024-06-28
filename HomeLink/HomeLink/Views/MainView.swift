//
//  MainView.swift
//  HomeLink
//
//  Created by Joshua Figueroa on 6/19/24.
//

import SwiftUI

struct MainView: View {
    @Binding var getStarted: Bool
    @ObservedObject var bleManager: BLEManager
    @State private var showAlert = false
    
    var body: some View {
        if getStarted {
            DataView(bleManager: bleManager, getStarted: getStarted)
        } else {
            LauncherView(bleManager: bleManager, getStarted: $getStarted)
        }
    }
}

#Preview("Launcher") {
    MainView(getStarted: .constant(false), bleManager: MockBLEManager(isConnected: true))
}

#Preview("Data View") {
    MainView(getStarted: .constant(true), bleManager: MockBLEManager(isConnected: true))
}
