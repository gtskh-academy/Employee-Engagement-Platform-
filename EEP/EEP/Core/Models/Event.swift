//
//  Event.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation


enum EventStatus: String, Codable {
    case waitlisted = "Waitlisted"
    case open = "Open"
    case closed = "Closed"
}

enum EventCategory: String, Codable,CaseIterable,Identifiable {
    case teamBuilding = "Team Building"
    case workshop = "Workshop"
    case sports = "Sports"
    case wellness = "Wellness"
    case cultural = "Cultural"
    case happyFridays = "Happy Fridays"
    var id: String { self.rawValue }

}

struct Event: Identifiable, Codable {
    let id: UUID
    
    // Date
    let day: Int
    let month: String
    let year: Int
    
    // Main info
    let title: String
    let startTime: String
    let endTime: String
    let location: String
    let eventCategory: String
    let eventByCategory: EventCategory
    
    // Description
    let description: String
    let status: EventStatus
    let registeredCount: Int
    let isFull: Bool
    
    static let array: [Event] = [
        Event(
            id: UUID(),
            day: 24, month: "JAN", year: 2025,
            title: "Happy Friday: Game Night",
            startTime: "06:00", endTime: "09:00",
            location: "Recreation Lounge",
            eventCategory: "Games", eventByCategory: .happyFridays,
            description: "Unwind after a productive week with board games and video games.",
            status: .waitlisted, registeredCount: 30, isFull: true
        ),
        Event(
            id: UUID(),
            day: 26, month: "JAN", year: 2025,
            title: "iOS Study Jam",
            startTime: "04:00", endTime: "06:00",
            location: "Room 201",
            eventCategory: "Development", eventByCategory: .workshop,
            description: "Hands-on session to practice SwiftUI and iOS fundamentals together.",
            status: .open, registeredCount: 18, isFull: false
        ),
        Event(
            id: UUID(),
            day: 28, month: "JAN", year: 2025,
            title: "Tech Talk: Future of AI",
            startTime: "05:30", endTime: "07:00",
            location: "Main Hall",
            eventCategory: "Technology", eventByCategory: .workshop,
            description: "Join us for a talk on trends and real-world applications of AI.",
            status: .open, registeredCount: 42, isFull: false
        ),
        Event(
            id: UUID(),
            day: 30, month: "JAN", year: 2025,
            title: "Yoga Morning",
            startTime: "07:00", endTime: "08:30",
            location: "Wellness Center",
            eventCategory: "Wellness", eventByCategory: .wellness,
            description: "Start your day with energizing yoga.",
            status: .open, registeredCount: 12, isFull: false
        ),
        Event(
            id: UUID(),
            day: 31, month: "JAN", year: 2025,
            title: "Networking Lunch",
            startTime: "12:00", endTime: "13:30",
            location: "Cafeteria",
            eventCategory: "Social", eventByCategory: .teamBuilding,
            description: "Meet and connect with peers over lunch.",
            status: .open, registeredCount: 25, isFull: false
        ),
        Event(
            id: UUID(),
            day: 1, month: "FEB", year: 2025,
            title: "Hackathon Kickoff",
            startTime: "09:00", endTime: "10:00",
            location: "Lab 101",
            eventCategory: "Tech", eventByCategory: .workshop,
            description: "Official start of the 48-hour hackathon.",
            status: .open, registeredCount: 50, isFull: false
        ),
        Event(
            id: UUID(),
            day: 3, month: "FEB", year: 2025,
            title: "Marketing Workshop",
            startTime: "14:00", endTime: "16:00",
            location: "Room 303",
            eventCategory: "Business", eventByCategory: .workshop,
            description: "Learn key marketing strategies for startups.",
            status: .open, registeredCount: 20, isFull: false
        ),
        Event(
            id: UUID(),
            day: 5, month: "FEB", year: 2025,
            title: "Tech Quiz Night",
            startTime: "18:00", endTime: "20:00",
            location: "Recreation Lounge",
            eventCategory: "Quiz", eventByCategory: .cultural,
            description: "Test your tech knowledge in a fun quiz.",
            status: .open, registeredCount: 35, isFull: false
        )
    ]
}

struct SimpleEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: String
}

let popularEvents: [SimpleEvent] = [
    SimpleEvent(title: "Tech Talk: AI in Business", date: "Jan 26, 2025"),
    SimpleEvent(title: "Annual Meetup", date: "Feb 2, 2025"),
    SimpleEvent(title: "Startup Pitch Night", date: "Feb 10, 2025")
]

extension Event {
    func eventDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.date(from: "\(day) \(month) \(year)")
    }
}
