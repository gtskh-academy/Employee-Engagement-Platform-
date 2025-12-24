//
//  EventModel.swift
//  EEP
//
//  Created by m1 pro on 24.12.25.
//



// dummy data for browseView
import Foundation

struct EventModel: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let dateText: String
    let time: String
    let location: String
    let status: EventStatus
    let spotsLeft: Int?
    let isLastWeek: Bool
    
    
    static let dummyEvents: [EventModel] = [
        EventModel(title: "Annual Team Building Summit",description: "Join us for a full day of engaging activities and workshops.",dateText: "Fri, Dec 19, 2025",time: "09:00 AM - 05:00 PM",location: "Conference Hall",status: .available,spotsLeft: 8,isLastWeek: false),
        EventModel(title: "Escape Room Challenge: The Heist",description: "Solve puzzles and escape before time runs out!",dateText: "Sat, Dec 20, 2025",time: "02:00 PM - 03:30 PM",location: "Puzzle House",status: .registered,spotsLeft: nil,isLastWeek: true),
        EventModel(title: "Corporate Sports Day 2025",description: "Friendly competition across sporting activities.",dateText: "Sun, Dec 28, 2025",time: "10:00 AM - 04:00 PM",location: "Sports Complex",status: .full,spotsLeft: nil,isLastWeek: false)]
    
    enum EventStatus {
        case available
        case registered
        case full
    }
}
