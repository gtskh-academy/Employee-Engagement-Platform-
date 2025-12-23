//
//  LoginView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import SwiftUI

struct SignInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                VStack(spacing: 12) {
                    Text("Sign In")
                        .font(.system(size: 40))
                    
                    Text("Enter your credentials to access your account")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 24)
                
                VStack(spacing: 20) {
                    CommonTextField(
                        title: "Email",
                        placeholder: "Enter your email",
                        text: $email
                    )
                    
                    CommonTextField(
                        title: "Password",
                        placeholder: "Enter your password",
                        text: $password,
                        isSecure: true
                    )
                }
                
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: rememberMe ? "checkmark.square" : "square")
                            .onTapGesture {
                                rememberMe.toggle()
                            }
                        Text("Remember me")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text("Forgot Password?")
                        .font(.system(size: 15))
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: 340)
                
                Spacer().frame(height: 32)
                
                CommonButton(title: "Sign In") {
                }
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    
                    NavigationLink("Sign Up") {
                        SignUpView()
                    }
                    .foregroundStyle(.black)
                }
                .font(.footnote)
                
                Spacer()
            }
            .padding(.top, 70)
        }
    }
}

#Preview {
    SignInView()
}

