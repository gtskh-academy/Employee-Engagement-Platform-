import SwiftUI

struct CreateAccount: View {
    @StateObject private var viewModel = CreateAccountViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
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
                                        text: $viewModel.firstName)
                        .frame(width: 165)
                        if let error = viewModel.firstNameError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        CommonTextField(title: "Last Name",
                                        placeholder: "Doe",
                                        text: $viewModel.lastName)
                        .frame(width: 165)
                        if let error = viewModel.lastNameError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    CommonTextField(title: "Email",
                                    placeholder: "john.doe@company.com",
                                    text: $viewModel.email)
                    if let error = viewModel.emailError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    
                    HStack(spacing: 10) {
                        CommonTextField(title: "Phone Number",
                                        placeholder: "+995 555 11 11 11",
                                        text: $viewModel.phoneNumber)
                        .frame(width: 230)
                        if let error = viewModel.phoneNumberError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Button(action: { viewModel.sendOTP() }) {
                            HStack {
                                if viewModel.isSendingOTP {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .tint(.white)
                                }
                                Text(viewModel.isSendingOTP ? "Sending..." : "Send OTP")
                                    .font(.system(size: 15))
                                    .bold()
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 100, height: 50)
                            .background(viewModel.isPhoneNumberValid && !viewModel.isSendingOTP ? Color.black : Color.gray.opacity(0.5))
                            .cornerRadius(5)
                            .shadow(color: .gray.opacity(0.3), radius: 5)
                        }
                        .disabled(!viewModel.isPhoneNumberValid || viewModel.isSendingOTP)
                        .padding(.top, 25)
                    }
                    
                    if viewModel.showOTP {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("⛊ Enter OTP Code")
                                .font(.footnote)
                                .foregroundColor(.black.opacity(0.7))
                            OTPView(otpCode: $viewModel.otpCode) { code in
                                viewModel.verifyOTP(code: code)
                            }
                            if let otpError = viewModel.otpError {
                                Text(otpError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.top, 8)
                            }
                            if viewModel.isVerifyingOTP {
                                HStack {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                    Text("Verifying...")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 8)
                            }
                            if viewModel.isPhoneVerified {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Phone verified")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                                .padding(.top, 8)
                            }
                        }
                        .padding(.horizontal, 25)
                        .padding(.top, 10)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Department")
                            .font(.system(size: 15))
                        Menu {
                            if viewModel.isLoadingDepartments {
                                ProgressView()
                            } else {
                                ForEach(viewModel.departments) { dept in
                                    Button(dept.name) {
                                        viewModel.selectedDepartment = dept
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.selectedDepartment?.name ?? "Select Department")
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
                        if let error = viewModel.departmentError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal, 25)
                    
                    VStack(spacing: 10) {
                        VStack {
                            CommonTextField(title: "Password",
                                            placeholder: "Create Password",
                                            text: $viewModel.password,
                                            isSecure: true,
                                            iconName: "questionmark.circle")
                            if let error = viewModel.passwordError {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                            }
                            Text("Password must be at least 8 characters with uppercase, lowercase, and number.")
                                .font(.system(size: 13))
                                .foregroundColor(.black.opacity(0.5))
                                .padding(.leading, 12)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        VStack {
                            CommonTextField(title: "Confirm Password",
                                            placeholder: "Confirm Password",
                                            text: $viewModel.confirmPassword,
                                            isSecure: true,
                                            iconName: "questionmark.circle")
                            if let error = viewModel.confirmPasswordError {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                            }
                            HStack(spacing: 20) {
                                Image(systemName: viewModel.agreedToTerms ? "checkmark.square" : "rectangle")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .bold()
                                    .padding(.bottom, 20)
                                    .onTapGesture { viewModel.agreedToTerms.toggle() }
                                Text("I agree to the Terms of Service and Privacy Policy")
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.horizontal, 25)
                            .padding(.vertical, 20)
                            if let error = viewModel.termsError {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                            }
                        }
                        
                        if let generalError = viewModel.generalError {
                            Text(generalError)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                        }
                        
                        CommonButton(title: viewModel.isLoading ? "Creating Account..." : "Create Account") {
                            viewModel.createAccount()
                        }
                        .frame(width: 340)
                        .disabled(viewModel.isLoading)
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 30)
                    }
                }
                .scrollIndicators(.hidden)
            }
            .onAppear {
                viewModel.authViewModel = authViewModel
                viewModel.loadDepartments()
            }
        }
    }
}
