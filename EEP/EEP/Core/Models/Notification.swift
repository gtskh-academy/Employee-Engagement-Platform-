//
//  Notification.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct NotificationResponse: Codable {
    let notifications: [UserNotification]
    let pageNumber: Int
    let pageSize: Int
    let totalItems: Int
    let totalPages: Int
}

struct UserNotification: Identifiable, Codable {
    let id: Int
    let title: String
    let message: String
    let createdAt: String
    let eventId: Int?
    let eventTitle: String?
    var isRead: Bool
    let type: String
    
    var notificationType: NotificationType {
        switch type {
        case "RegistrationConfirmed", "WaitlistUpdate":
            return .registrations
        case "Reminder24Hour", "Reminder1Hour":
            return .reminders
        case "EventUpdate", "EventCancelled":
            return .updates
        default:
            return .all
        }
    }
    
    var formattedTime: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: createdAt) else {
            formatter.formatOptions = [.withInternetDateTime]
            guard let date = formatter.date(from: createdAt) else {
                return createdAt
            }
            return formatRelativeTime(from: date)
        }
        
        return formatRelativeTime(from: date)
    }
    
    private func formatRelativeTime(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let days = components.day, days > 0 {
            if days == 1 {
                return "Yesterday"
            } else if days < 7 {
                return "\(days) days ago"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy"
                return dateFormatter.string(from: date)
            }
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
    
    var icon: String {
        switch type {
        case "RegistrationConfirmed":
            return "calendar"
        case "WaitlistUpdate":
            return "person.crop.circle.badge.plus"
        case "Reminder24Hour", "Reminder1Hour":
            return "bell"
        case "EventUpdate", "EventCancelled":
            return "info.circle"
        default:
            return "info.circle"
        }
    }
}

