//
//  ProfileViewModel.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func loadUserData() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedUser = try await AuthService.shared.getCurrentUser()
                await MainActor.run {
                    self.user = fetchedUser
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    // Try to use cached user if API call fails
                    self.user = TokenManager.shared.currentUser
                    if self.user == nil {
                        self.errorMessage = "Failed to load user data: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
}

