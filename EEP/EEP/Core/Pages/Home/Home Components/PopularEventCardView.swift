//
//  PopularEventCardView.swift
//  team11
//
//  Created by m1 pro on 23.12.25.
//

import SwiftUI

struct PopularEventCardView: View {
    let event: SimpleEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Image placeholder
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                Text("Event Image")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
            .frame(width: .infinity,height: 140)
            .cornerRadius(12)
            
            Text(event.title)
                .font(.system(size: 16, weight: .medium))
                .lineLimit(2)
            
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                Text(event.date)
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
