//
//  TagView.swift
//  EEP
//
//  Created by m1 pro on 24.12.25.
//

import SwiftUI

struct TagView: View {
    let text: String
    var background: Color = .white
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(background == .black ? .white : .black)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(background)
            .cornerRadius(16)
    }
}
