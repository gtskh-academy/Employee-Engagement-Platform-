//
//  SimpleOTPView.swift
//  EEP
//
//  Created by m1 pro on 24.12.25.
//


import SwiftUI

struct OTPView: View {
    @Binding var otpCode: String
    var onComplete: ((String) -> Void)?
    
    @State private var otp: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedIndex: Int?

    var body: some View {
        HStack {
            ForEach(0..<6, id: \.self) { index in
                OTPTextField(text: $otp[index], isFocused: focusedIndex == index)
                    .focused($focusedIndex, equals: index)
                    .onChange(of: otp[index]) { _, newValue in
                        handleInputChange(index: index, value: newValue)
                    }
            }
        }
        .onChange(of: otp) { _, _ in
            let code = otp.joined()
            otpCode = code
            if code.count == 6 {
                onComplete?(code)
            }
        }
    }

    private func handleInputChange(index: Int, value: String) {
        if value.count == 1 {
            if index < 5 { focusedIndex = index + 1 }
            else { focusedIndex = nil }
        }
        if value.isEmpty && index > 0 { focusedIndex = index - 1 }
    }
}
