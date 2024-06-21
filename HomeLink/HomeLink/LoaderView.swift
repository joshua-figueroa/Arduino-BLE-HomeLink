//
//  LoaderView.swift
//  HomeLink
//
//  Created by Joshua Figueroa on 6/19/24.
//

import SwiftUI

struct LoaderView: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 15) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    .animation(
                        Animation
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2)
                        
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
        .onDisappear {
            isAnimating = false
        }
    }
}

#Preview {
    LoaderView()
}
