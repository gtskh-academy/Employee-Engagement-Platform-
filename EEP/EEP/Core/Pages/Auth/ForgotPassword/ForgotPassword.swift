//
//  ResetAccount.swift
//  EEP
//
//  Created by m1 pro on 23.12.25.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var emailForUpadePass: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 20) {
                    Text("Forgot Password")
                        .font(.title)
                    
                    Text("Enter your email and we'll send you a link to reset your password.")
                        .font(.footnote)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                Spacer().frame(height: 50)
                
                VStack {
                    CommonTextField(
                        title: "Email",
                        placeholder: "✉ Enter your email",
                        text: $emailForUpadePass
                    )
                    
                    Spacer().frame(height: 50)
                    
                    CommonButton(title: "Send Reset Link") {
                    }
                    
                    Spacer().frame(height: 50)
                    
                    NavigationLink("← Back to Sign in") {
                        SignIn()
                    }
                    .foregroundStyle(.black)
                }
            }
            .padding(.bottom, 120)
        }
    }
}

#Preview {
    ForgotPasswordView()
}

