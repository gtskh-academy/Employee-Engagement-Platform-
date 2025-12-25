//
//  BrowseEvent.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct BrowseEvent: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let categoryId: Int?
    let categoryName: String?
    let categoryImageUrl: String?
    let startDateTime: String
    let endDateTime: String
    let location: BrowseEventLocation?
    let capacitySettings: CapacitySettings?
    let notificationSettings: NotificationSettings?
    let confirmedCount: Int?
    let isFull: Bool?
    let imageUrl: String?
    
    // Helper to parse date strings
    private func parseDate(_ dateString: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: dateString) {
            return date
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: dateString)
    }
    
    // Computed property for formatted date
    var formattedDate: String {
        guard let date = parseDate(startDateTime) else { return "" }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM d, yyyy"
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")
        return displayFormatter.string(from: date)
    }
    
    // Computed property for day
    var day: Int {
        guard let date = parseDate(startDateTime) else { return 0 }
        return Calendar.current.component(.day, from: date)
    }
    
    // Computed property for month
    var month: String {
        guard let date = parseDate(startDateTime) else { return "" }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM"
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")
        return displayFormatter.string(from: date).uppercased()
    }
    
    // Computed property for start time
    var startTime: String {
        guard let date = parseDate(startDateTime) else { return "" }
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        return timeFormatter.string(from: date)
    }
    
    // Computed property for end time
    var endTime: String {
        guard let date = parseDate(endDateTime) else { return "" }
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        return timeFormatter.string(from: date)
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
    
    // Status string for display
    var statusString: String {
        if isFull == true {
            return "Full"
        }
        if let confirmed = confirmedCount, let max = capacitySettings?.maxCapacity {
            let spotsLeft = max - confirmed
            return spotsLeft > 0 ? "\(spotsLeft) spots left" : "Full"
        }
        return "Open"
    }
}

struct BrowseEventLocation: Codable {
    let id: Int?
    let venueName: String?
    let address: String?
    let city: String?
    let room: String?
    let floor: String?
    
    // Custom decoding for type field - can be Int or String
    let type: String?
    
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
        
        // Try to decode type as String first, if that fails try as Int and convert
        if let stringValue = try? container.decode(String.self, forKey: .type) {
            type = stringValue
        } else if let intValue = try? container.decode(Int.self, forKey: .type) {
            type = String(intValue)
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

