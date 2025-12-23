//
//  CategoryCardView.swift
//  team11
//
//  Created by m1 pro on 23.12.25.
//


import SwiftUI

struct CategoryCardView: View {
    let category: Category
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.system(size: 30))
                .foregroundColor(.gray)
            
            Text(category.title)
                .font(.system(size: 14, weight: .medium))
                .multilineTextAlignment(.center)
            
            Text("\(category.eventsCount) events")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

import Foundation

struct Category: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let eventsCount: Int
    
    static let mock: [Category] = [
        Category(title: "Team\nBuilding", icon: "person.3.fill", eventsCount: 12),
        Category(title: "Sports", icon: "figure.run", eventsCount: 8),
        Category(title: "Workshops", icon: "person.crop.rectangle", eventsCount: 18),
        Category(title: "Happy\nFridays", icon: "wineglass", eventsCount: 4),
        Category(title: "Cultural", icon: "theatermasks", eventsCount: 6),
        Category(title: "Wellness", icon: "heart.fill", eventsCount: 9)
    ]
}

