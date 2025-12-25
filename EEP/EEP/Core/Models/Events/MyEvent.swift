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
    let waitlistedCount: Int?
    let createdBy: String?
    let imageUrl: String?
    
    var id: Int { eventId }
    
    enum CodingKeys: String, CodingKey {
        case eventId
        case id
        case title, description, startDateTime, endDateTime
        case categoryId, categoryName, categoryImageUrl
        case location, activities, speakers, capacitySettings
        case confirmedCount, myStatus, myPosition
        case waitlistedCount, createdBy
        case imageUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
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
        imageUrl = try? container.decode(String.self, forKey: .imageUrl)
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
        try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
    }
    
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
        createdBy: String? = nil,
        imageUrl: String? = nil
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
        self.imageUrl = imageUrl
    }
    
    var formattedDate: String {
        guard let date = parseDate(from: startDateTime) else {
            return ""
        }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM d, yyyy"
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")
        return displayFormatter.string(from: date)
    }
    
    func parseDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: dateString) {
            return date
        }
        
        isoFormatter.formatOptions = [.withInternetDateTime]
        return isoFormatter.date(from: dateString)
    }
    
    var day: Int {
        guard let date = parseDate(from: startDateTime) else {
            return 0
        }
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }
    
    var month: String {
        guard let date = parseDate(from: startDateTime) else {
            return ""
        }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM"
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")
        return displayFormatter.string(from: date).uppercased()
    }
    
    var year: Int {
        guard let date = parseDate(from: startDateTime) else {
            return 0
        }
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
    
    var startTime: String {
        guard let date = parseDate(from: startDateTime) else {
            return ""
        }
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        return timeFormatter.string(from: date)
    }
    
    var endTime: String {
        guard let date = parseDate(from: endDateTime) else {
            return ""
        }
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        return timeFormatter.string(from: date)
    }
    
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
    
    var descriptionText: String {
        return description.isEmpty ? title : description
    }
    
    var durationHours: Int {
        guard let startDate = parseDate(from: startDateTime),
              let endDate = parseDate(from: endDateTime) else {
            return 0
        }
        let duration = endDate.timeIntervalSince(startDate)
        return Int(duration / 3600)
    }
    
    var timeRangeWithDuration: String {
        if durationHours > 0 {
            return "\(startTime) - \(endTime) (\(durationHours)h)"
        }
        return "\(startTime) - \(endTime)"
    }
}

extension MyEvent {
    init(from browseEvent: BrowseEvent) {
        let eventLocation: EventLocation?
        if let browseLocation = browseEvent.location {
            let typeInt: Int?
            if let typeString = browseLocation.type {
                typeInt = Int(typeString)
            } else {
                typeInt = nil
            }
            
            var locationDict: [String: Any] = [:]
            if let id = browseLocation.id { locationDict["id"] = id }
            if let type = typeInt { locationDict["type"] = type }
            if let venueName = browseLocation.venueName { locationDict["venueName"] = venueName }
            if let address = browseLocation.address { locationDict["address"] = address }
            if let city = browseLocation.city { locationDict["city"] = city }
            if let room = browseLocation.room { locationDict["room"] = room }
            if let floor = browseLocation.floor { locationDict["floor"] = floor }
            
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
            activities: nil,
            speakers: nil,
            capacitySettings: browseEvent.capacitySettings,
            confirmedCount: browseEvent.confirmedCount,
            myStatus: nil,
            myPosition: nil,
            waitlistedCount: nil,
            createdBy: nil,
            imageUrl: browseEvent.imageUrl
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

