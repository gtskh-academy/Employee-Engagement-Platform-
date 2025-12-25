//
//  MyEvent.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct MyEvent: Identifiable, Codable {
    let eventId: Int
    let title: String
    let description: String
    let startDateTime: String
    let endDateTime: String
    let categoryId: Int?
    let categoryName: String?
    let categoryImageUrl: String?
    let location: EventLocation?
    let activities: [EventActivity]?
    let speakers: [EventSpeaker]?
    let capacitySettings: CapacitySettings?
    let confirmedCount: Int?
    let myStatus: String?
    let myPosition: Int?
    let waitlistedCount: Int? // Added for /api/Events/{id} response
    let createdBy: String? // Added for /api/Events/{id} response
    
    var id: Int { eventId }
    
    // CodingKeys to handle both "id" and "eventId" from API
    enum CodingKeys: String, CodingKey {
        case eventId
        case id // For /api/Events/{id} endpoint
        case title, description, startDateTime, endDateTime
        case categoryId, categoryName, categoryImageUrl
        case location, activities, speakers, capacitySettings
        case confirmedCount, myStatus, myPosition
        case waitlistedCount, createdBy
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try to decode eventId first, if not found try id
        if let eventIdValue = try? container.decode(Int.self, forKey: .eventId) {
            eventId = eventIdValue
        } else if let idValue = try? container.decode(Int.self, forKey: .id) {
            eventId = idValue
        } else {
            throw DecodingError.keyNotFound(CodingKeys.eventId, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Neither eventId nor id found"))
        }
        
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        startDateTime = try container.decode(String.self, forKey: .startDateTime)
        endDateTime = try container.decode(String.self, forKey: .endDateTime)
        categoryId = try? container.decode(Int.self, forKey: .categoryId)
        categoryName = try? container.decode(String.self, forKey: .categoryName)
        categoryImageUrl = try? container.decode(String.self, forKey: .categoryImageUrl)
        location = try? container.decode(EventLocation.self, forKey: .location)
        activities = try? container.decode([EventActivity].self, forKey: .activities)
        speakers = try? container.decode([EventSpeaker].self, forKey: .speakers)
        capacitySettings = try? container.decode(CapacitySettings.self, forKey: .capacitySettings)
        confirmedCount = try? container.decode(Int.self, forKey: .confirmedCount)
        myStatus = try? container.decode(String.self, forKey: .myStatus)
        myPosition = try? container.decode(Int.self, forKey: .myPosition)
        waitlistedCount = try? container.decode(Int.self, forKey: .waitlistedCount)
        createdBy = try? container.decode(String.self, forKey: .createdBy)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(eventId, forKey: .eventId)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(startDateTime, forKey: .startDateTime)
        try container.encode(endDateTime, forKey: .endDateTime)
        try container.encodeIfPresent(categoryId, forKey: .categoryId)
        try container.encodeIfPresent(categoryName, forKey: .categoryName)
        try container.encodeIfPresent(categoryImageUrl, forKey: .categoryImageUrl)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(activities, forKey: .activities)
        try container.encodeIfPresent(speakers, forKey: .speakers)
        try container.encodeIfPresent(capacitySettings, forKey: .capacitySettings)
        try container.encodeIfPresent(confirmedCount, forKey: .confirmedCount)
        try container.encodeIfPresent(myStatus, forKey: .myStatus)
        try container.encodeIfPresent(myPosition, forKey: .myPosition)
        try container.encodeIfPresent(waitlistedCount, forKey: .waitlistedCount)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
    }
    
    // Memberwise initializer
    init(
        eventId: Int,
        title: String,
        description: String,
        startDateTime: String,
        endDateTime: String,
        categoryId: Int? = nil,
        categoryName: String? = nil,
        categoryImageUrl: String? = nil,
        location: EventLocation? = nil,
        activities: [EventActivity]? = nil,
        speakers: [EventSpeaker]? = nil,
        capacitySettings: CapacitySettings? = nil,
        confirmedCount: Int? = nil,
        myStatus: String? = nil,
        myPosition: Int? = nil,
        waitlistedCount: Int? = nil,
        createdBy: String? = nil
    ) {
        self.eventId = eventId
        self.title = title
        self.description = description
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.categoryImageUrl = categoryImageUrl
        self.location = location
        self.activities = activities
        self.speakers = speakers
        self.capacitySettings = capacitySettings
        self.confirmedCount = confirmedCount
        self.myStatus = myStatus
        self.myPosition = myPosition
        self.waitlistedCount = waitlistedCount
        self.createdBy = createdBy
    }
    
    // Computed property for formatted date
    var formattedDate: String {
        guard let date = parseDate(from: startDateTime) else {
            return ""
        }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM d, yyyy"
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")
        return displayFormatter.string(from: date)
    }
    
    // Helper to parse date from startDateTime
    func parseDate(from dateString: String) -> Date? {
        // Try various date formats
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // Try with fractional seconds and Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        // Try with fractional seconds (2 decimals) without Z (for /api/Events/{id})
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        // Try with fractional seconds (3 decimals) without Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        // Try without fractional seconds with Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        // Try without fractional seconds and without Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        // Try ISO8601DateFormatter as fallback
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: dateString) {
            return date
        }
        
        // Try without fractional seconds
        isoFormatter.formatOptions = [.withInternetDateTime]
        return isoFormatter.date(from: dateString)
    }
    
    // Computed property for day
    var day: Int {
        guard let date = parseDate(from: startDateTime) else {
            return 0
        }
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }
    
    // Computed property for month
    var month: String {
        guard let date = parseDate(from: startDateTime) else {
            return ""
        }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM"
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")
        return displayFormatter.string(from: date).uppercased()
    }
    
    // Computed property for year
    var year: Int {
        guard let date = parseDate(from: startDateTime) else {
            return 0
        }
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
    
    // Computed property for start time
    var startTime: String {
        guard let date = parseDate(from: startDateTime) else {
            return ""
        }
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        return timeFormatter.string(from: date)
    }
    
    // Computed property for end time
    var endTime: String {
        guard let date = parseDate(from: endDateTime) else {
            return ""
        }
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
    
    // Computed property for description
    var descriptionText: String {
        return description.isEmpty ? title : description
    }
    
    // Computed property for duration in hours
    var durationHours: Int {
        guard let startDate = parseDate(from: startDateTime),
              let endDate = parseDate(from: endDateTime) else {
            return 0
        }
        let duration = endDate.timeIntervalSince(startDate)
        return Int(duration / 3600) // Convert seconds to hours
    }
    
    // Computed property for time range with duration
    var timeRangeWithDuration: String {
        if durationHours > 0 {
            return "\(startTime) - \(endTime) (\(durationHours)h)"
        }
        return "\(startTime) - \(endTime)"
    }
}

// Extension to convert BrowseEvent to MyEvent
extension MyEvent {
    init(from browseEvent: BrowseEvent) {
        // Convert BrowseEventLocation to EventLocation
        let eventLocation: EventLocation?
        if let browseLocation = browseEvent.location {
            // Convert type from String to Int if possible
            let typeInt: Int?
            if let typeString = browseLocation.type {
                typeInt = Int(typeString)
            } else {
                typeInt = nil
            }
            
            // Create a dictionary to encode as JSON, then decode as EventLocation
            var locationDict: [String: Any] = [:]
            if let id = browseLocation.id { locationDict["id"] = id }
            if let type = typeInt { locationDict["type"] = type }
            if let venueName = browseLocation.venueName { locationDict["venueName"] = venueName }
            if let address = browseLocation.address { locationDict["address"] = address }
            if let city = browseLocation.city { locationDict["city"] = city }
            if let room = browseLocation.room { locationDict["room"] = room }
            if let floor = browseLocation.floor { locationDict["floor"] = floor }
            
            // Encode to JSON and decode as EventLocation
            if let jsonData = try? JSONSerialization.data(withJSONObject: locationDict),
               let decoded = try? JSONDecoder().decode(EventLocation.self, from: jsonData) {
                eventLocation = decoded
            } else {
                eventLocation = nil
            }
        } else {
            eventLocation = nil
        }
        
        self.init(
            eventId: browseEvent.id,
            title: browseEvent.title,
            description: browseEvent.description,
            startDateTime: browseEvent.startDateTime,
            endDateTime: browseEvent.endDateTime,
            categoryId: browseEvent.categoryId,
            categoryName: browseEvent.categoryName,
            categoryImageUrl: browseEvent.categoryImageUrl,
            location: eventLocation,
            activities: nil, // BrowseEvent doesn't have activities
            speakers: nil, // BrowseEvent doesn't have speakers
            capacitySettings: browseEvent.capacitySettings,
            confirmedCount: browseEvent.confirmedCount,
            myStatus: nil, // BrowseEvent doesn't have myStatus
            myPosition: nil // BrowseEvent doesn't have myPosition
        )
    }
}

struct EventActivity: Codable {
    let id: Int
    let eventId: Int
    let title: String
    let description: String?
    let startTime: String
    let durationMinutes: Int?
    let location: String?
}

struct EventSpeaker: Codable {
    let id: Int
    let eventId: Int
    let name: String
    let role: String?
    let imageUrl: String?
}

