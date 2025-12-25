//
//  MyEventsViewModel.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation
import SwiftUI

class MyEventsViewModel: ObservableObject {
    @Published var events: [MyEvent] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func loadEvents() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedEvents = try await EventsService.shared.getMyEvents()
                await MainActor.run {
                    self.events = fetchedEvents
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
                        self.errorMessage = "Failed to load events: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    func getEventDates() -> Set<DateComponents> {
        var dateSet = Set<DateComponents>()
        let calendar = Calendar.current
        
        for event in events {
            if let date = event.parseDate(from: event.startDateTime) {
                let components = calendar.dateComponents([.year, .month, .day], from: date)
                dateSet.insert(components)
            }
        }
        
        return dateSet
    }
    
    func getEvents(for date: Date) -> [MyEvent] {
        let calendar = Calendar.current
        let targetComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        return events.filter { event in
            guard let eventDate = event.parseDate(from: event.startDateTime) else {
                return false
            }
            let eventComponents = calendar.dateComponents([.year, .month, .day], from: eventDate)
            return eventComponents.year == targetComponents.year &&
                   eventComponents.month == targetComponents.month &&
                   eventComponents.day == targetComponents.day
        }
    }
    
    func getFormattedDateString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
}


