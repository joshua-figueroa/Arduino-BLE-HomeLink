//
//  LauncherView.swift
//  WatchHomeLink Watch App
//
//  Created by Joshua Figueroa on 7/1/24.
//

import SwiftUI

struct LauncherView: View {
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 5) {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                
                Text("Arduino BLE")
                    .foregroundColor(.primary)
                Text("HomeLink")
                    .foregroundColor(.primary)
            }
            .font(.title3)
            .fontWeight(.bold)
            .padding(.vertical, 10)
            
            Text("Welcome to BLE HomeLink! Open the app on your iPhone to get started")
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: .all)
    }
}

#Preview {
    LauncherView()
}
