//
//  PopularEventCardView.swift
//  team11
//
//  Created by m1 pro on 23.12.25.
//

import SwiftUI

struct PopularEventCardView: View {
    let event: TrendingEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Cached image with placeholder
            CachedAsyncImage(url: event.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                    Image(systemName: "photo")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                }
            }
            .frame(width: 200, height: 140)
            .clipped()
            .cornerRadius(12)
            
            Text(event.title)
                .font(.system(size: 16, weight: .medium))
                .lineLimit(2)
            
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                Text(event.formattedDate.isEmpty ? "Date TBD" : event.formattedDate)
                    .font(.system(size: 14))
            }
            .foregroundColor(.gray)
        }
        .frame(width: 200)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}
