//
//  ContentView.swift
//  HomeLink
//
//  Created by Joshua Figueroa on 6/19/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("getStarted") var getStarted: Bool = false
    
    var body: some View {
        #if targetEnvironment(simulator)
            MainView(getStarted: $getStarted, bleManager: SimulatedBLEManager())
        #else
            MainView(getStarted: $getStarted, bleManager: BLEManager.shared)
        #endif
    }
}

#Preview {
    ContentView()
}
