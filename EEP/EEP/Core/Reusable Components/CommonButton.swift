//
//  CommonButton.swift
//  team11
//
//  Created by m1 pro on 21.12.25.
//

import SwiftUI

struct CommonButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .frame(maxWidth: 340, minHeight: 50)
                .background(Color.black)
                .cornerRadius(6)
        }
    }
}
