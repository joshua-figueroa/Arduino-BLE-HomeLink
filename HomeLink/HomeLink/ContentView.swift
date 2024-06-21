//
//  ContentView.swift
//  HomeLink
//
//  Created by Joshua Figueroa on 6/19/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        MainView(bleManager: BLEManager())
    }
}

#Preview {
    ContentView()
}
