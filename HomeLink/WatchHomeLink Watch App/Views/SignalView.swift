//
//  SignalView.swift
//  WatchHomeLink Watch App
//
//  Created by Joshua Figueroa on 8/1/24.
//

import SwiftUI

struct SignalView: View {
    let strength: Int
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(0..<3) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(index < strength ? Color.green : Color.gray)
                    .frame(width: 10, height: CGFloat(10 + (index * 10)))
                    .padding(.bottom, 5)
            }
        }
        .frame(width: 35, height: 35)
    }
}

#Preview {
    SignalView(strength: 3)
}
