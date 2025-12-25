//
//  BrowseViewModel.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation
import SwiftUI

class BrowseViewModel: ObservableObject {
    @Published var events: [BrowseEvent] = []
    @Published var categories: [EventCategoryModel] = []
    @Published var isLoadingEvents: Bool = false
    @Published var isLoadingCategories: Bool = false
    @Published var eventsError: String?
    @Published var categoriesError: String?
    @Published var selectedCategoryId: Int? = nil
    @Published var searchText: String = ""
    
    var filteredEvents: [BrowseEvent] {
        var filtered = events
        
        if let categoryId = selectedCategoryId {
            filtered = filtered.filter { $0.categoryId == categoryId }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.description.localizedCaseInsensitiveContains(searchText) ||
                (event.categoryName?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        return filtered
    }
    
    func loadEvents() {
        isLoadingEvents = true
        eventsError = nil
        
        Task {
            do {
                let fetchedEvents = try await EventsService.shared.getEvents()
                await MainActor.run {
                    self.events = fetchedEvents
                    self.isLoadingEvents = false
                }
            } catch {
                await MainActor.run {
                    self.isLoadingEvents = false
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .serverError(let message):
                            self.eventsError = message
                        case .invalidResponse:
                            self.eventsError = "Invalid response from server"
                        }
                    } else {
                        self.eventsError = "Failed to load events: \(error.localizedDescription)"
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
                }
            }
        }
    }
    
    func selectCategory(_ categoryId: Int?) {
        selectedCategoryId = categoryId
    }
}

