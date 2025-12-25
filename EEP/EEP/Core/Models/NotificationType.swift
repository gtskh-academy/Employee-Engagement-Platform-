//
//  NotificationType.swift
//  EEP
//
//  Created by m1 pro on 25.12.25.
//


import Foundation

// Dummy data for NotificationPage UI 
enum NotificationType: String, CaseIterable, Identifiable {
    case all = "All"
    case registrations = "Registrations"
    case reminders = "Reminders"
    case updates = "Updates"
    
    var id: String { rawValue }
}

struct AppNotification: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let time: String
    let type: NotificationType
    let isUnread: Bool
    let isNew: Bool
    let icon: String
}

extension AppNotification {
    static let dummy: [AppNotification] = [
        AppNotification(
            title: "Registration Confirmed",
            message: "You are now registered for the 'Leadership Workshop: Effective Communication'.",
            time: "15 minutes ago",
            type: .registrations,
            isUnread: true,
            isNew: true,
            icon: "calendar"
        ),
        AppNotification(
            title: "Event Reminder",
            message: "'Annual Team Building Summit' starts in 24 hours. Don't forget to join!",
            time: "1 hour ago",
            type: .reminders,
            isUnread: true,
            isNew: true,
            icon: "bell"
        ),
        AppNotification(
            title: "Event Update",
            message: "The location for 'Happy Friday: Game Night' has been changed to the Recreation Lounge.",
            time: "Yesterday",
            type: .updates,
            isUnread: false,
            isNew: false,
            icon: "info.circle"
        ),
        AppNotification(
            title: "Waitlist Update",
            message: "A spot has opened up for 'Tech Talk: AI in Business Operations'. You have been automatically registered.",
            time: "2 days ago",
            type: .registrations,
            isUnread: false,
            isNew: false,
            icon: "person.crop.circle.badge.plus"
        ),
        AppNotification(
            title: "Cancellation",
            message: "Your registration for the 'Wellness Wednesday Yoga' has been successfully cancelled.",
            time: "Dec 12, 2025",
            type: .updates,
            isUnread: false,
            isNew: false,
            icon: "calendar.badge.xmark"
        )
    ]
}
