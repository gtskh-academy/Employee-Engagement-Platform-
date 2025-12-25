import SwiftUI

struct SignIn: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: SignInViewModel
    
    init() {
        let tempAuthVM = AuthViewModel()
        _viewModel = StateObject(wrappedValue: SignInViewModel(authViewModel: tempAuthVM))
    }
    
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
                        text: $viewModel.email
                    )
                    if let emailError = viewModel.emailError {
                        Text(emailError)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                    }
                    
                    CommonTextField(
                        title: "Password",
                        placeholder: "Enter your password",
                        text: $viewModel.password,
                        isSecure: true
                    )
                    if let passwordError = viewModel.passwordError {
                        Text(passwordError)
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
                
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: viewModel.rememberMe ? "checkmark.square" : "square")
                            .onTapGesture { viewModel.rememberMe.toggle() }
                        Text("Remember me")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    NavigationLink {
                        ForgotPasswordView()
                    } label: {
                        Text("Forgot Password?")
                            .font(.system(size: 15))
                            .foregroundStyle(.black)
                    }
                }
                .frame(maxWidth: 340)
                
                Spacer().frame(height: 32)
                
                CommonButton(title: viewModel.isLoading ? "Signing In..." : "Sign In") {
                    viewModel.signIn()
                }
                .disabled(viewModel.isLoading)
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    NavigationLink("Sign Up") {
                        CreateAccount()
                            .environmentObject(authViewModel)
                    }
                    .foregroundStyle(.black)
                }
                .font(.footnote)
                Spacer()
            }
            .padding(.top, 70)
            .onAppear {
                viewModel.authViewModel = authViewModel
            }
        }
    }
}
