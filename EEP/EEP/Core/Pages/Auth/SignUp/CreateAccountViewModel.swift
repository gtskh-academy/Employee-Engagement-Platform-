//
//  CreateAccountViewModel.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation
import SwiftUI

class CreateAccountViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var selectedDepartment: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var agreedToTerms: Bool = false
    @Published var showOTP: Bool = false
    @Published var otpCode: String = ""
    @Published var isPhoneVerified: Bool = false
    @Published var otpError: String?
    @Published var isSendingOTP: Bool = false
    @Published var isVerifyingOTP: Bool = false
    
    @Published var firstNameError: String?
    @Published var lastNameError: String?
    @Published var emailError: String?
    @Published var phoneNumberError: String?
    @Published var departmentError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
    @Published var termsError: String?
    
    @Published var isLoading: Bool = false
    @Published var navigateToSignIn: Bool = false
    @Published var generalError: String?
    
    var authViewModel: AuthViewModel?
    
    let departments = ["Engineering", "Marketing", "Sales", "HR", "Finance", "Operations"]
    
    func validateFirstName() -> Bool {
        if firstName.isEmpty {
            firstNameError = "First name is required"
            return false
        }
        firstNameError = nil
        return true
    }
    
    func validateLastName() -> Bool {
        if lastName.isEmpty {
            lastNameError = "Last name is required"
            return false
        }
        lastNameError = nil
        return true
    }
    
    func validateEmail() -> Bool {
        if email.isEmpty {
            emailError = "Email is required"
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            emailError = "Invalid email format"
            return false
        }
        
        emailError = nil
        return true
    }
    
    func validatePhoneNumber() -> Bool {
        // Phone number is optional - if empty, it's valid
        if phoneNumber.isEmpty {
            phoneNumberError = nil
            return true
        }
        
        // Remove spaces, dashes, and other formatting characters
        let cleanedPhone = phoneNumber.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "+", with: "")
        
        // Phone number must start with 5 and have exactly 9 digits
        let phoneRegex = "^5[0-9]{8}$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        
        if !phonePredicate.evaluate(with: cleanedPhone) {
            phoneNumberError = "Phone number must start with 5 and have exactly 9 digits"
            return false
        }
        
        phoneNumberError = nil
        return true
    }
    
    func validateDepartment() -> Bool {
        if selectedDepartment.isEmpty {
            departmentError = "Please select a department"
            return false
        }
        departmentError = nil
        return true
    }
    
    func validatePassword() -> Bool {
        if password.isEmpty {
            passwordError = "Password is required"
            return false
        }
        
        if password.count < 8 {
            passwordError = "Password must be at least 8 characters"
            return false
        }
        
        passwordError = nil
        return true
    }
    
    func validateConfirmPassword() -> Bool {
        if confirmPassword.isEmpty {
            confirmPasswordError = "Please confirm your password"
            return false
        }
        
        if password != confirmPassword {
            confirmPasswordError = "Passwords do not match"
            return false
        }
        
        confirmPasswordError = nil
        return true
    }
    
    func validateTerms() -> Bool {
        if !agreedToTerms {
            termsError = "You must agree to the terms of service and privacy policy"
            return false
        }
        termsError = nil
        return true
    }
    
    func validateAll() -> Bool {
        // Phone number is optional, but if provided, it must be valid
        let phoneValid = phoneNumber.isEmpty || validatePhoneNumber()
        
        let isValid = validateFirstName() &&
                     validateLastName() &&
                     validateEmail() &&
                     phoneValid &&
                     validateDepartment() &&
                     validatePassword() &&
                     validateConfirmPassword() &&
                     validateTerms()
        return isValid
    }
    
    func sendOTP() {
        // Phone number must be provided and valid to send OTP
        guard !phoneNumber.isEmpty else {
            phoneNumberError = "Phone number is required to send OTP"
            return
        }
        
        guard validatePhoneNumber() else {
            return
        }
        
        isSendingOTP = true
        otpError = nil
        
        let cleanedPhone = phoneNumber.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "+", with: "")
        
        let request = SendPhoneCodeRequest(phoneNumber: cleanedPhone)
        
        Task {
            do {
                try await AuthService.shared.sendPhoneCode(request)
                
                await MainActor.run {
                    self.isSendingOTP = false
                    self.showOTP = true
                    self.otpCode = ""
                }
            } catch {
                await MainActor.run {
                    self.isSendingOTP = false
                    
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .serverError(let message):
                            self.otpError = message
                        case .invalidResponse:
                            self.otpError = "Invalid response from server"
                        }
                    } else {
                        self.otpError = "Failed to send OTP: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    func verifyOTP(code: String) {
        guard !code.isEmpty, code.count == 6 else {
            otpError = "Please enter a valid 6-digit code"
            return
        }
        
        isVerifyingOTP = true
        otpError = nil
        
        let cleanedPhone = phoneNumber.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "+", with: "")
        
        let request = VerifyPhoneRequest(phoneNumber: cleanedPhone, code: code)
        
        Task {
            do {
                try await AuthService.shared.verifyPhone(request)
                
                await MainActor.run {
                    self.isVerifyingOTP = false
                    self.isPhoneVerified = true
                    self.otpCode = code
                }
            } catch {
                await MainActor.run {
                    self.isVerifyingOTP = false
                    
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .serverError(let message):
                            self.otpError = message
                        case .invalidResponse:
                            self.otpError = "Invalid response from server"
                        }
                    } else {
                        self.otpError = "Failed to verify OTP: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    var isPhoneNumberValid: Bool {
        // Phone is optional - if empty, button should be disabled
        guard !phoneNumber.isEmpty else {
            return false
        }
        
        let cleanedPhone = phoneNumber.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "+", with: "")
        
        let phoneRegex = "^5[0-9]{8}$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: cleanedPhone)
    }
    
    func createAccount() {
        guard validateAll() else {
            return
        }
        
        // Phone verification is only required if phone number is provided
        if !phoneNumber.isEmpty && !isPhoneVerified {
            generalError = "Please verify your phone number with OTP"
            return
        }
        
        isLoading = true
        generalError = nil
        
        // Clean phone number before sending (or use empty string if not provided)
        let cleanedPhone = phoneNumber.isEmpty ? "" : phoneNumber.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "+", with: "")
        
        let request = RegisterRequest(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: cleanedPhone,
            department: selectedDepartment
        )
        
        Task {
            do {
                let response = try await AuthService.shared.register(request)
                
                await MainActor.run {
                    // Save token and user info
                    TokenManager.shared.saveAuthResponse(
                        response,
                        phoneNumber: phoneNumber,
                        department: selectedDepartment
                    )
                    
                    // Update AuthViewModel if available
                    self.authViewModel?.isAuthenticated = true
                    self.authViewModel?.currentUser = TokenManager.shared.currentUser
                    
                    self.isLoading = false
                    // Don't navigate to SignIn - ContentView will handle navigation based on auth state
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .serverError(let message):
                            self.generalError = message
                        case .invalidResponse:
                            self.generalError = "Invalid response from server"
                        }
                    } else {
                        self.generalError = "Failed to create account: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    func clearErrors() {
        firstNameError = nil
        lastNameError = nil
        emailError = nil
        phoneNumberError = nil
        departmentError = nil
        passwordError = nil
        confirmPasswordError = nil
        termsError = nil
        generalError = nil
    }
}

