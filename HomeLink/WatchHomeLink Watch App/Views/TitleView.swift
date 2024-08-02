//
//  TitleView.swift
//  WatchHomeLink Watch App
//
//  Created by Joshua Figueroa on 8/1/24.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)

            Text("Arduino")
                .foregroundColor(.primary)
            Text("HomeLink")
                .foregroundColor(.primary)
        }
        .font(.title3)
        .fontWeight(.bold)
        .padding(.vertical, 15)
    }
}

#Preview {
    TitleView()
}
