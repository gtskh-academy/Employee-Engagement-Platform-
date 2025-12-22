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
    
    @Published var firstNameError: String?
    @Published var lastNameError: String?
    @Published var emailError: String?
    @Published var phoneNumberError: String?
    @Published var departmentError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
    @Published var termsError: String?
    
    @Published var isLoading: Bool = false
    
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
        if phoneNumber.isEmpty {
            phoneNumberError = "Phone number is required"
            return false
        }
        
        // Basic phone validation
        let phoneRegex = "^[0-9]{10,}$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        
        if !phonePredicate.evaluate(with: phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")) {
            phoneNumberError = "Invalid phone number"
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
        let isValid = validateFirstName() &&
                     validateLastName() &&
                     validateEmail() &&
                     validatePhoneNumber() &&
                     validateDepartment() &&
                     validatePassword() &&
                     validateConfirmPassword() &&
                     validateTerms()
        return isValid
    }
    
    func sendOTP() {
        if validateEmail() && validatePhoneNumber() {
            // Dummy OTP sending - just show OTP screen
            showOTP = true
        }
    }
    
    func createAccount() {
        guard validateAll() else {
            return
        }
        
        isLoading = true
        
        // Dummy account creation - replace with actual API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            // On success, navigate to sign in or home
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
    }
}

