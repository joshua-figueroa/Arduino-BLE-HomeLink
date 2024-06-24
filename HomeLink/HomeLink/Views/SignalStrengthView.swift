//
//  SignalStrengthView.swift
//  HomeLink
//
//  Created by Joshua Figueroa on 6/23/24.
//

import SwiftUI

struct SignalStrengthView: View {
    let signalStrength: Int
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text("Device Signal:")
                .padding(.trailing, 5)
            HStack(alignment: .bottom, spacing: 2) {
                ForEach(0..<3) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(index < signalStrength ? Color.green : Color.gray)
                        .frame(width: 10, height: CGFloat(10 + (index * 10)))
                        .padding(.bottom, 3)
                }
            }
        }
    }
}

#Preview("Strength: 3") {
    SignalStrengthView(signalStrength: 3)
}

#Preview("Strength: 2") {
    SignalStrengthView(signalStrength: 2)
}
