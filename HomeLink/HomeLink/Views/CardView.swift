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
    let width: CGFloat
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width * 0.5, height: width * 0.5)
                .foregroundColor(imageColor)
            Text(title)
                .font(.headline)
                .padding(.top, 15)
            if loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 10)
            } else {
                Text(content)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
            }
        }
        .frame(width: width, height: width * 1.5)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.3), radius: 5)
    }
}

#Preview {
    CardView(image: "thermometer", title: "Temperature", content: "24°C", imageColor: .red, loading: false, width: 120)
        .previewLayout(.sizeThatFits)
        .padding()
}

#Preview("Loading") {
    CardView(image: "thermometer", title: "Temperature", content: "24°C", imageColor: .red, loading: true, width: 120)
        .previewLayout(.sizeThatFits)
        .padding()
}
