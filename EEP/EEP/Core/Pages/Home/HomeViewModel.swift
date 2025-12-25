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
    @Published var myEvents: [MyEvent] = []
    @Published var isLoadingMyEvents: Bool = false
    @Published var myEventsError: String?
    @Published var showAllEventsSheet: Bool = false
    @Published var categories: [EventCategoryModel] = []
    @Published var isLoadingCategories: Bool = false
    @Published var categoriesError: String?
    
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
    
    func loadMyEvents() {
        isLoadingMyEvents = true
        myEventsError = nil
        
        Task {
            do {
                let events = try await EventsService.shared.getMyEvents()
                await MainActor.run {
                    self.myEvents = events
                    self.isLoadingMyEvents = false
                }
            } catch {
                await MainActor.run {
                    self.isLoadingMyEvents = false
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .serverError(let message):
                            self.myEventsError = message
                        case .invalidResponse:
                            self.myEventsError = "Invalid response from server"
                        }
                    } else {
                        self.myEventsError = "Failed to load events: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    func loadCategories() {
        isLoadingCategories = true
        categoriesError = nil
        
        Task {
            do {
                let fetchedCategories = try await EventsService.shared.getCategories()
                await MainActor.run {
                    self.categories = fetchedCategories
                    self.isLoadingCategories = false
                }
            } catch {
                await MainActor.run {
                    self.isLoadingCategories = false
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .serverError(let message):
                            self.categoriesError = message
                        case .invalidResponse:
                            self.categoriesError = "Invalid response from server"
                        }
                    } else {
                        self.categoriesError = "Failed to load categories: \(error.localizedDescription)"
                    }
                    // Fallback to empty array - will show nothing or use hardcoded
                }
            }
        }
    }
}

