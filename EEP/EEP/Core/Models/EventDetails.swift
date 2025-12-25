//
//  EventDetails.swift
//  EEP
//
//  Created by m1 pro on 25.12.25.
//

import Foundation

// dummy data for noticiation details sheet
struct EventDetails {
    let title: String
    let dateTime: String
    let location: String
}

extension EventDetails {
    static let dummy = EventDetails(
        title: "Tech Talk: AI in Business",
        dateTime: "Jan 26, 2025, 11:00 AM - 12:30 PM",
        location: "Virtual Meeting"
    )
}
