import Foundation
import SwiftUI

class CreateAccountViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var selectedDepartment: Department?
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
    @Published var generalError: String?
    @Published var departments: [Department] = []
    @Published var isLoadingDepartments: Bool = false
    @Published var departmentsError: String?
    
    var authViewModel: AuthViewModel?
    
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
        
        if !ValidationUtils.isValidEmail(email) {
            emailError = "Invalid email format"
            return false
        }
        
        emailError = nil
        return true
    }
    
    private func cleanPhoneNumber(_ phone: String) -> String {
        return phone.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "+", with: "")
    }
    
    func validatePhoneNumber() -> Bool {
        if phoneNumber.isEmpty {
            phoneNumberError = nil
            return true
        }
        
        let cleanedPhone = cleanPhoneNumber(phoneNumber)
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
        if selectedDepartment == nil {
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
        guard !phoneNumber.isEmpty else {
            phoneNumberError = "Phone number is required to send OTP"
            return
        }
        
        guard validatePhoneNumber() else {
            return
        }
        
        isSendingOTP = true
        otpError = nil
        
        let cleanedPhone = cleanPhoneNumber(phoneNumber)
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
        
        let cleanedPhone = cleanPhoneNumber(phoneNumber)
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
        guard !phoneNumber.isEmpty else {
            return false
        }
        
        let cleanedPhone = cleanPhoneNumber(phoneNumber)
        let phoneRegex = "^5[0-9]{8}$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: cleanedPhone)
    }
    
    func createAccount() {
        guard validateAll() else {
            return
        }
        
        if !phoneNumber.isEmpty && !isPhoneVerified {
            generalError = "Please verify your phone number with OTP"
            return
        }
        
        isLoading = true
        generalError = nil
        
        let cleanedPhone = phoneNumber.isEmpty ? "" : cleanPhoneNumber(phoneNumber)
        
        let request = RegisterRequest(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: cleanedPhone,
            department: selectedDepartment?.name ?? ""
        )
        
        Task {
            do {
                let response = try await AuthService.shared.register(request)
                
                await MainActor.run {
                    TokenManager.shared.saveAuthResponse(
                        response,
                        phoneNumber: phoneNumber,
                        department: selectedDepartment?.name ?? ""
                    )
                    
                    self.authViewModel?.isAuthenticated = true
                    self.authViewModel?.currentUser = TokenManager.shared.currentUser
                    self.isLoading = false
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
    
    func loadDepartments() {
        isLoadingDepartments = true
        departmentsError = nil
        
        Task {
            do {
                let fetchedDepartments = try await AuthService.shared.getDepartments(onlyActive: true)
                await MainActor.run {
                    self.departments = fetchedDepartments
                    self.isLoadingDepartments = false
                }
            } catch {
                await MainActor.run {
                    self.isLoadingDepartments = false
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .serverError(let message):
                            self.departmentsError = message
                        case .invalidResponse:
                            self.departmentsError = "Invalid response from server"
                        }
                    } else {
                        self.departmentsError = "Failed to load departments: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
}

