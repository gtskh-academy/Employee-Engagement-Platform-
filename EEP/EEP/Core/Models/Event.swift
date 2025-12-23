//
//  Event.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct Event: Identifiable,Codable {
    let id: UUID
    
    // Date
    let day: Int
    let month: String
    
    // Main info
    let title: String
    let startTime: String
    let endTime: String
    let location: String
    
    // Description
    let description: String
    let status: EventStatus
    let registeredCount: Int
    let isFull: Bool
    
    static let array: [Event] = [
        Event(
        id: UUID(),day: 24,month: "JAN",title: "Happy Friday: Game Night",startTime: "06:00 ",endTime: "09:00 ",location: "Recreation Lounge",description: "Unwind after a productive week with board games and video games.",status: .waitlisted,registeredCount: 30,isFull: true),
        Event(id: UUID(),day: 26,month: "JAN",title: "iOS Study Jam",startTime: "04:00 ",endTime: "06:00 ",location: "Room 201",description: "Hands-on session to practice SwiftUI and iOS fundamentals together.",status: .open,registeredCount: 18,isFull: false),
        Event(id: UUID(),day: 28,month: "JAN",title: "Tech Talk: Future of AI",startTime: "05:30 ",endTime: "07:00 ",location: "Main Hall",description: "Join us for a talk on trends and real-world applications of AI.",status: .open,registeredCount: 42,isFull: false)]
}
enum EventStatus: String, Codable {
    case waitlisted = "Waitlisted"
    case open = "Open"
    case closed = "Closed"
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
