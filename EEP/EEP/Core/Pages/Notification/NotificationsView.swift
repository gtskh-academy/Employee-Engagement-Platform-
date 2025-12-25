//
//  NotificationsView.swift
//  EEP
//
//  Created by m1 pro on 25.12.25.
//

import SwiftUI
import Foundation

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()
    @State private var showEventDetail = false
    @State private var selectedEventDetails: EventDetails?
    @State private var isLoadingEvent = false
    @State private var eventLoadError: String?
    
    var body: some View {
        VStack {
            header
            tabs
            
            if viewModel.isLoading && viewModel.notifications.isEmpty {
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Loading notifications...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.top, 100)
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.red)
                    Text("Error")
                        .font(.title2)
                        .foregroundColor(.red)
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 100)
                .padding(.horizontal)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        section(title: "NEW", items: viewModel.newNotifications)
                        
                        section(title: "EARLIER", items: viewModel.earlierNotifications)
                        
                        if viewModel.hasMorePages {
                            Button(action: {
                                viewModel.loadMoreNotifications()
                            }) {
                                HStack {
                                    if viewModel.isLoadingMore {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                    }
                                    Text(viewModel.isLoadingMore ? "Loading..." : "Load More")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                            }
                            .disabled(viewModel.isLoadingMore)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: $showEventDetail) {
            Group {
                if let eventDetails = selectedEventDetails {
                    EventDetailSheet(event: eventDetails)
                } else if isLoadingEvent {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Loading event details...")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .presentationDetents([.medium])
                } else if let error = eventLoadError {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                        Text("Error")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Button("Close") {
                            showEventDetail = false
                        }
                        .padding(.top)
                    }
                    .padding()
                    .presentationDetents([.medium])
                } else {
                    EmptyView()
                }
            }
        }
        .onAppear {
            viewModel.loadNotifications()
        }
        .refreshable {
            viewModel.refreshNotifications()
        }
    }
    
    private func loadEventDetails(eventId: Int) {
        isLoadingEvent = true
        eventLoadError = nil
        selectedEventDetails = nil
        showEventDetail = true
        
        Task {
            do {
                let event = try await EventsService.shared.getEventById(eventId)
                var registrationId: Int? = nil
                do {
                    registrationId = try await EventsService.shared.getRegistrationId(for: eventId)
                } catch {
                }
                
                await MainActor.run {
                    var eventDetails = EventDetails(from: event)
                    if let registrationId = registrationId {
                        eventDetails = EventDetails(
                            title: eventDetails.title,
                            dateTime: eventDetails.dateTime,
                            location: eventDetails.location,
                            eventId: eventDetails.eventId,
                            registrationId: registrationId
                        )
                    }
                    self.selectedEventDetails = eventDetails
                    self.isLoadingEvent = false
                }
            } catch {
                await MainActor.run {
                    self.isLoadingEvent = false
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .serverError(let message):
                            self.eventLoadError = message
                        case .invalidResponse:
                            self.eventLoadError = "Invalid response from server"
                        }
                    } else {
                        self.eventLoadError = "Failed to load event details: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
}

extension NotificationsView {
    
    var header: some View {
        HStack {
            Spacer()
            Text("Notifications")
                .font(.headline)
            Spacer()
        }
        .padding()
    }
    
    var tabs: some View {
        HStack {
            ForEach(NotificationType.allCases) { tab in
                VStack {
                    Text(tab.rawValue)
                        .font(.subheadline)
                        .foregroundColor(viewModel.selectedTab == tab ? .black : .gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Rectangle()
                        .fill(viewModel.selectedTab == tab ? Color.black : Color.clear)
                        .frame(height: 2)
                }
                .onTapGesture {
                    viewModel.selectedTab = tab
                }
            }
        }
        .padding(.horizontal)
    }
}

extension NotificationsView {
    
    func section(title: String, items: [UserNotification]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if !items.isEmpty {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                ForEach(items) { notification in
                    NotificationCard(notification: notification)
                        .onTapGesture {
                            if !notification.isRead {
                                viewModel.markAsRead(notificationId: notification.id)
                            }
                            
                            if notification.notificationType == .registrations,
                               let eventId = notification.eventId {
                                loadEventDetails(eventId: eventId)
                            }
                        }
                }
            }
        }
    }
}
