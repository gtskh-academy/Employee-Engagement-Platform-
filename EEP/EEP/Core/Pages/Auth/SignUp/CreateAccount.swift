//
//  CreateAccount.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//
import SwiftUI

struct CreateAccount: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var confrimedPassword: String = ""
    @State private var selectedDepartment: String = ""
    @State private var agreeToTerms: Bool = false
    
    private let departments = ["enginner", "designer", "manager", "marketer", "tester"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 25) {
                    Text("Create Account")
                        .font(.system(size: 25))
                    Text("Enter your details to get started.")
                        .font(.system(size: 18))
                        .foregroundStyle(.black.opacity(0.6))
                }
                .padding(.top, 10)
                
                HStack(spacing: 10) {
                    CommonTextField(title: "First Name",
                                    placeholder: "John",
                                    text: $firstName)
                        .frame(width: 165)
                    CommonTextField(title: "Last Name",
                                    placeholder: "Doe",
                                    text: $lastName)
                        .frame(width: 165)
                }
                
                CommonTextField(title: "Email",
                                placeholder: "john.doe@company.com",
                                text: $email)
                
                HStack(spacing: 10) {
                    CommonTextField(title: "Phone Number",
                                    placeholder: "+1 (000) 000-0000",
                                    text: $phoneNumber)
                        .frame(width: 230)
                    Button(action: {}) {
                        Text("Send OTP")
                            .font(.system(size: 15))
                            .bold()
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 50)
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(5)
                            .shadow(color: .gray.opacity(0.3), radius: 5)
                    }
                    .padding(.top, 25)
                }
                VStack(alignment: .leading) {
                    Text("⛊ Enter OTP Code")
                        .font(.footnote)
                    OTPView()

                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Department")
                        .font(.system(size: 15))
                    Menu {
                        ForEach(departments, id: \.self) { dept in
                            Button(dept.capitalized) { selectedDepartment = dept }
                        }
                    } label: {
                        HStack {
                            Text(selectedDepartment.isEmpty ? "Select Department" : selectedDepartment.capitalized)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .frame(width: 340, height: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 25)
                
                VStack(spacing: 10) {
                    VStack {
                        CommonTextField(title: "Password",
                                        placeholder: "Create Password",
                                        text: $password,
                                        isSecure: true,
                                        iconName: "questionmark.circle")
                        Text("Password must be at least 8 characters with uppercase, lowercase, and number.")
                            .font(.system(size: 13))
                            .foregroundColor(.black.opacity(0.5))
                            .padding(.leading, 12)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    VStack {
                        CommonTextField(title: "Password",
                                        placeholder: "Confirm Password",
                                        text: $confrimedPassword,
                                        isSecure: true,
                                        iconName: "questionmark.circle")
                        HStack(spacing: 20) {
                            Image(systemName: agreeToTerms ? "checkmark.square" : "rectangle")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .bold()
                                .padding(.bottom, 20)
                                .onTapGesture { agreeToTerms.toggle() }
                            Text("I agree to the Terms of Service and Privacy Policy")
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 20)
                    }
                    
                    CommonButton(title: "Create Account") { }
                        .frame(width: 340)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 30)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    CreateAccount()
}
