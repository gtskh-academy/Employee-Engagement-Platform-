//
//  ProfileView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // User Profile Section
                    VStack(spacing: 16) {
                        Image("PersonIcon")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.top, 8)
                        } else if let user = viewModel.user {
                            VStack(spacing: 12) {
                                Text("\(user.firstName) \(user.lastName)")
                                    .font(.system(size: 24))
                                    .fontWeight(.semibold)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    UserInfoRow(label: "Email", value: user.email)
                                    
                                    if let department = user.department, !department.isEmpty {
                                        UserInfoRow(label: "Department", value: department)
                                    }
                                    
                                    if let role = user.role, !role.isEmpty {
                                        UserInfoRow(label: "Role", value: role)
                                    }
                                }
                                .padding(.top, 8)
                            }
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Logout Section
                    VStack(spacing: 12) {
                        Text("Are you sure you want to log out?")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        CommonButton(title: "Log Out") {
                            authViewModel.logout()
                        }
                        .frame(maxWidth: 340)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadUserData()
            }
        }
    }
}

struct UserInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label + ":")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 14))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}

