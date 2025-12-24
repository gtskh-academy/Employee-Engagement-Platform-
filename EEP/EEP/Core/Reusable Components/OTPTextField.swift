//
//  OTPTextField.swift
//  EEP
//
//  Created by m1 pro on 24.12.25.
//


import SwiftUI


struct OTPTextField: View {
    
    @Binding var text: String
    let isFocused: Bool
    
    var body: some View {
        TextField("", text: $text)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .frame(width: 50, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFocused ? Color.black : Color.gray.opacity(0.5), lineWidth: 1)
            )
            .onChange(of: text) { _, newValue in
                if newValue.count > 1 {
                    text = String(newValue.last!)
                }
            }
    }
}

