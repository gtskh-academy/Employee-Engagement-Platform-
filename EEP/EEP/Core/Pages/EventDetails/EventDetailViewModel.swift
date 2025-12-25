//
//  EventDetailViewModel.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation
import SwiftUI

class EventDetailViewModel: ObservableObject {
    @Published var event: MyEvent
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private let eventId: Int?
    let shouldFetchDetails: Bool
    
    init(event: MyEvent, shouldFetchDetails: Bool = false) {
        self.event = event
        self.eventId = event.id
        self.shouldFetchDetails = shouldFetchDetails
    }
    
    init(eventId: Int) {
        self.event = MyEvent(
            eventId: eventId,
            title: "",
            description: "",
            startDateTime: "",
            endDateTime: "",
            categoryId: nil,
            categoryName: nil,
            categoryImageUrl: nil,
            location: nil,
            activities: nil,
            speakers: nil,
            capacitySettings: nil,
            confirmedCount: nil,
            myStatus: nil,
            myPosition: nil,
            waitlistedCount: nil,
            createdBy: nil,
            imageUrl: nil
        )
        self.eventId = eventId
        self.shouldFetchDetails = true
    }
    
    func loadEventDetails() {
        guard shouldFetchDetails, let eventId = eventId else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedEvent = try await EventsService.shared.getEventById(eventId)
                await MainActor.run {
                    self.event = fetchedEvent
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
                        self.errorMessage = "Failed to load event details: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    @Published var isRegistering: Bool = false
    @Published var registrationSuccess: Bool = false
    @Published var registrationErrorMessage: String?
    
    func registerForEvent() {
        guard let eventId = eventId else {
            registrationErrorMessage = "Event ID not available"
            return
        }
        
        isRegistering = true
        registrationErrorMessage = nil
        registrationSuccess = false
        
        Task {
            do {
                let response = try await EventsService.shared.registerForEvent(eventId: eventId)
                await MainActor.run {
                    self.isRegistering = false
                    self.registrationSuccess = true
                    NotificationRefreshManager.shared.postRefreshNotification()
                }
            } catch {
                await MainActor.run {
                    self.isRegistering = false
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .serverError(let message):
                            self.registrationErrorMessage = message
                        case .invalidResponse:
                            self.registrationErrorMessage = "Invalid response from server"
                        }
                    } else {
                        self.registrationErrorMessage = "Failed to register: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    var categoryName: String? {
        return event.categoryName
    }
    
    var myStatus: String? {
        return event.myStatus
    }
    
    var formattedDate: String {
        return event.formattedDate
    }
    
    var timeRange: String {
        return "\(event.startTime) - \(event.endTime)"
    }
    
    var locationString: String {
        return event.locationString
    }
    
    var spotsLeft: Int {
        let confirmed = event.confirmedCount ?? 0
        let maxCapacity = event.capacitySettings?.maxCapacity ?? 0
        return max(0, maxCapacity - confirmed)
    }
    
    var registeredCount: Int {
        return event.confirmedCount ?? 0
    }
    
    var descriptionText: String {
        return event.descriptionText
    }
    
    var hasAgenda: Bool {
        return true
    }
    
    var agendaItems: [AgendaItem] {
        if let activities = event.activities, !activities.isEmpty {
            return activities.enumerated().map { index, activity in
                AgendaItem(
                    number: index + 1,
                    time: formatActivityTime(activity.startTime),
                    title: activity.title,
                    description: activity.description,
                    location: activity.location
                )
            }
        } else {
            // hardcoded fallback
            return [
                AgendaItem(
                    number: 1,
                    time: "02:00 PM",
                    title: "Welcome & Introduction",
                    description: "Overview of the workshop goals and key topics.",
                    location: nil
                ),
                AgendaItem(
                    number: 2,
                    time: "02:15 PM",
                    title: "The Art of Active Listening",
                    description: "Interactive exercises on understanding and responding.",
                    location: nil
                ),
                AgendaItem(
                    number: 3,
                    time: "03:30 PM",
                    title: "Q&A and Closing Remarks",
                    description: "Open forum and summary of key takeaways.",
                    location: nil
                )
            ]
        }
    }
    
    var hasSpeakers: Bool {
        return true
    }
    
    var speakers: [SpeakerItem] {
        if let eventSpeakers = event.speakers, !eventSpeakers.isEmpty {
            return eventSpeakers.map { speaker in
                SpeakerItem(
                    name: speaker.name,
                    role: speaker.role ?? ""
                )
            }
        } else {
            return [
                SpeakerItem(name: "Sarah Johnson", role: "VP of Human Resources"),
                SpeakerItem(name: "David Chen", role: "Lead Corporate Trainer")
            ]
        }
    }
    
    private func formatActivityTime(_ timeString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SS",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ss"
        ]
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: timeString) {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "hh:mm a"
                timeFormatter.locale = Locale(identifier: "en_US_POSIX")
                return timeFormatter.string(from: date)
            }
        }
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: timeString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            timeFormatter.locale = Locale(identifier: "en_US_POSIX")
            return timeFormatter.string(from: date)
        }
        
        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: timeString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            timeFormatter.locale = Locale(identifier: "en_US_POSIX")
            return timeFormatter.string(from: date)
        }
        
        return timeString
    }
}

