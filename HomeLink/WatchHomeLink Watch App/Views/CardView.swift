//
//  CardView.swift
//  WatchHomeLink Watch App
//
//  Created by Joshua Figueroa on 8/1/24.
//

import SwiftUI

struct CardView: View {
    let image, title, content: String
    let imageColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(imageColor)
                .frame(width: 35, height: 35)

            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.semibold)
                Text(content)
            }
        }
    }
}

#Preview {
    CardView(image: "thermometer", title: "Temperature", content: "24°C", imageColor: .red)
        .previewLayout(.sizeThatFits)
        .padding()
}
