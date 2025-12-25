//
//  CommonTextField.swift
//  team11
//
//  Created by m1 pro on 21.12.25.
//

import SwiftUI

struct CommonTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    let iconName: String?

    init(title: String, placeholder: String, text: Binding<String>, isSecure: Bool = false, iconName: String? = nil) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.iconName = iconName
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                
                Spacer()
                
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .foregroundColor(.gray)
                }
            }
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
                    .frame(height: 45)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            } else {
                TextField(placeholder, text: $text)
                    .padding()
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }
        }
        .frame(maxWidth: 340)
    }
}
