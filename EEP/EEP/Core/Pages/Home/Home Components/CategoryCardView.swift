//
//  CategoryCardView.swift
//  team11
//
//  Created by m1 pro on 23.12.25.
//


import SwiftUI

struct CategoryCardView: View {
    let category: EventCategoryModel
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: category.systemIcon)
                .font(.system(size: 30))
                .foregroundColor(.gray)
            
            Text(category.name)
                .font(.system(size: 14, weight: .medium))
                .multilineTextAlignment(.center)
            
            Text("\(category.count) events")
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

