//
//  HomeViewModel.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var trendingEvents: [TrendingEvent] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    @Published var isLoadingUser: Bool = false
    
    func loadTrendingEvents() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let events = try await EventsService.shared.getTrendingEvents()
                await MainActor.run {
                    self.trendingEvents = events
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .serverError(let message):
                            self.errorMessage = message
                        case .invalidResponse:
                            self.errorMessage = "Invalid response from server"
                        }
                    } else {
                        self.errorMessage = "Failed to load trending events: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    func loadCurrentUser() {
        isLoadingUser = true
        
        Task {
            do {
                let user = try await AuthService.shared.getCurrentUser()
                await MainActor.run {
                    self.currentUser = user
                    self.isLoadingUser = false
                }
            } catch {
                await MainActor.run {
                    self.isLoadingUser = false
                    // If user fetch fails, try to use cached user from TokenManager
                    self.currentUser = TokenManager.shared.currentUser
                }
            }
        }
    }
}

