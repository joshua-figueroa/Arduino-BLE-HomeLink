//
//  CardView.swift
//  HomeLink
//
//  Created by Joshua Figueroa on 6/23/24.
//

import SwiftUI

struct CardView: View {
    let image, title, content: String
    let imageColor: Color
    let loading: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(imageColor)
            Text(title)
                .font(.headline)
                .padding(.top, 10)
            if loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 5)
            } else {
                Text(content)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 5)
            }
        }
        .frame(width: 120, height: 170)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3), radius: 5)
    }
}

#Preview {
    CardView(image: "thermometer", title: "Temperature", content: "24°C", imageColor: .red, loading: false)
}

#Preview("Loading") {
    CardView(image: "thermometer", title: "Temperature", content: "24°C", imageColor: .red, loading: true)
}
