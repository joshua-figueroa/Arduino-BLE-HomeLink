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
        MainView(getStarted: $getStarted, bleManager: BLEManager())
    }
}

#Preview {
    ContentView()
}
