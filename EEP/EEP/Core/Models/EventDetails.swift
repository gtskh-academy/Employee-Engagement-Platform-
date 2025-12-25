//
//  EventDetails.swift
//  EEP
//
//  Created by m1 pro on 25.12.25.
//

import Foundation

struct EventDetails {
    let title: String
    let dateTime: String
    let location: String
    let eventId: Int?
    let registrationId: Int?
    
    init(title: String, dateTime: String, location: String, eventId: Int? = nil, registrationId: Int? = nil) {
        self.title = title
        self.dateTime = dateTime
        self.location = location
        self.eventId = eventId
        self.registrationId = registrationId
    }
}

extension EventDetails {
    static let dummy = EventDetails(
        title: "Tech Talk: AI in Business",
        dateTime: "Jan 26, 2025, 11:00 AM - 12:30 PM",
        location: "Virtual Meeting",
        eventId: 1,
        registrationId: 1
    )
    
    init(from event: MyEvent) {
        self.title = event.title
        
        var dateTimeString = ""
        if let startDate = event.parseDate(from: event.startDateTime) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let dateString = dateFormatter.string(from: startDate)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            timeFormatter.locale = Locale(identifier: "en_US_POSIX")
            let startTimeString = timeFormatter.string(from: startDate)
            
            var endTimeString = ""
            if let endDate = event.parseDate(from: event.endDateTime) {
                endTimeString = timeFormatter.string(from: endDate)
            }
            
            if !endTimeString.isEmpty {
                dateTimeString = "\(dateString), \(startTimeString) - \(endTimeString)"
            } else {
                dateTimeString = "\(dateString), \(startTimeString)"
            }
        }
        self.dateTime = dateTimeString.isEmpty ? "Date TBD" : dateTimeString
        
        self.location = event.locationString
        
        self.eventId = event.eventId
        
        self.registrationId = nil
    }
}
