//
//  NotificationsView.swift
//  EEP
//
//  Created by m1 pro on 25.12.25.
//


import SwiftUI

struct NotificationsView: View {
    
    @State private var selectedTab: NotificationType = .all
    @State private var showEventDetail = false
    @State private var selectedEvent: EventDetails?
    private let notifications = AppNotification.dummy
    
    var filteredNotifications: [AppNotification] {
        if selectedTab == .all {
            return notifications
        }
        return notifications.filter { $0.type == selectedTab }
    }
    
    var body: some View {
        VStack {
            header
            tabs
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    section(title: "NEW", items: filteredNotifications.filter { $0.isNew })
                    
                    section(title: "EARLIER", items: filteredNotifications.filter { !$0.isNew })
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showEventDetail) {
            if let event = selectedEvent {
                EventDetailSheet(event: event)
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
                        .foregroundColor(selectedTab == tab ? .black : .gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Rectangle()
                        .fill(selectedTab == tab ? Color.black : Color.clear)
                        .frame(height: 2)
                }
                .onTapGesture {
                    selectedTab = tab
                }
            }
        }
        .padding(.horizontal)
    }
}

extension NotificationsView {
    
    func section(title: String, items: [AppNotification]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if !items.isEmpty {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                ForEach(items) { notification in
                    NotificationCard(notification: notification)
                        .onTapGesture {
                            if notification.type == .registrations {
                                selectedEvent = EventDetails.dummy
                                showEventDetail = true
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    NotificationsView()
}
