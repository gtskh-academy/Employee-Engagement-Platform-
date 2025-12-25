import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewModel()
    
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
                        text: $viewModel.email
                    )
                    
                    if let emailError = viewModel.emailError {
                        Text(emailError)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    
                    if viewModel.showSuccessMessage {
                        Text("Reset link sent! Please check your email.")
                            .font(.caption)
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    
                    Spacer().frame(height: 50)
                    
                    CommonButton(title: viewModel.isLoading ? "Sending..." : "Send Reset Link") {
                        viewModel.sendResetLink()
                    }
                    .disabled(viewModel.isLoading)
                    
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

