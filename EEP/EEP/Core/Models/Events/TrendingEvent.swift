//
//  TrendingEvent.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct TrendingEvent: Identifiable, Codable {
    let id: Int
    let title: String
    let categoryId: Int?
    let categoryName: String?
    let categoryImageUrl: String?
    let startDateTime: String
    let location: EventLocation?
    let capacitySettings: CapacitySettings?
    let notificationSettings: NotificationSettings?
    let confirmedCount: Int?
    let isFull: Bool?
    let imageUrl: String?
    let tags: [String]?
    let myRegistrationStatus: String?
    
    // Computed property for formatted date
    var formattedDate: String {
        guard !startDateTime.isEmpty else {
            print("startDateTime is empty")
            return ""
        }
        
        // Try ISO8601DateFormatter first (handles format like "2026-05-15T09:00:00")
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        if let date = isoFormatter.date(from: startDateTime) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MMM d, yyyy"
            displayFormatter.locale = Locale(identifier: "en_US_POSIX")
            return displayFormatter.string(from: date)
        }
        
        // Fallback to DateFormatter
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = formatter.date(from: startDateTime) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MMM d, yyyy"
            displayFormatter.locale = Locale(identifier: "en_US_POSIX")
            return displayFormatter.string(from: date)
        }
        
        // Debug: Print what we're trying to parse
        print("Failed to parse date: '\(startDateTime)'")
        return ""
    }
    
    // Computed property for day
    var day: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = formatter.date(from: startDateTime) {
            let calendar = Calendar.current
            return calendar.component(.day, from: date)
        }
        return 0
    }
    
    // Computed property for month
    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = formatter.date(from: startDateTime) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MMM"
            return displayFormatter.string(from: date).uppercased()
        }
        return ""
    }
    
    // Computed property for start time
    var startTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = formatter.date(from: startDateTime) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            return timeFormatter.string(from: date)
        }
        return ""
    }
    
    // Computed property for end time (assuming 2 hours duration for now, or use API if available)
    var endTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = formatter.date(from: startDateTime) {
            let endDate = date.addingTimeInterval(2 * 60 * 60) // Add 2 hours
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            return timeFormatter.string(from: endDate)
        }
        return ""
    }
    
    // Computed property for location string
    var locationString: String {
        guard let location = location else { return "Location TBD" }
        if let venueName = location.venueName, !venueName.isEmpty {
            return venueName
        } else if let address = location.address, !address.isEmpty {
            return address
        } else if let city = location.city, !city.isEmpty {
            return city
        }
        return "Location TBD"
    }
    
    // Computed property for description (use title if description not available)
    var descriptionText: String {
        return title // For now, use title. Can be updated if API provides description
    }
}

struct EventLocation: Codable {
    let id: Int?
    let venueName: String?
    let address: String?
    let city: String?
    let room: String?
    let floor: String?
    
    // Custom decoding for type field - can be Int or String
    let type: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case venueName
        case address
        case city
        case room
        case floor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try? container.decode(Int.self, forKey: .id)
        venueName = try? container.decode(String.self, forKey: .venueName)
        address = try? container.decode(String.self, forKey: .address)
        city = try? container.decode(String.self, forKey: .city)
        room = try? container.decode(String.self, forKey: .room)
        floor = try? container.decode(String.self, forKey: .floor)
        
        // Try to decode type as Int first, if that fails try as String and convert
        if let intValue = try? container.decode(Int.self, forKey: .type) {
            type = intValue
        } else if let stringValue = try? container.decode(String.self, forKey: .type),
                  let intFromString = Int(stringValue) {
            type = intFromString
        } else {
            type = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(venueName, forKey: .venueName)
        try container.encodeIfPresent(address, forKey: .address)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(room, forKey: .room)
        try container.encodeIfPresent(floor, forKey: .floor)
    }
}

struct CapacitySettings: Codable {
    let id: Int?
    let eventId: Int?
    let maxCapacity: Int?
    let minCapacity: Int?
    let isWaitlistEnabled: Bool?
    let waitlistCapacity: Int?
    let isAutoApproveEnabled: Bool?
}

struct NotificationSettings: Codable {
    let eventId: Int?
    let isRegistrationConfirmation: Bool?
    let is24HourReminder: Bool?
    let is1HourReminder: Bool?
    let isWaitListUpdateNotified: Bool?
    let isEventUpdateNotified: Bool?
}

