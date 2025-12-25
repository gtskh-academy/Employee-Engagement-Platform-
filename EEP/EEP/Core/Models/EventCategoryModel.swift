//
//  EventCategoryModel.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct EventCategoryModel: Identifiable, Codable {
    let id: Int
    let name: String
    let imageUrl: String
    let count: Int
    
    var systemIcon: String {
        switch imageUrl.lowercased() {
        case "pi-users", "users":
            return "person.3.fill"
        case "pi-futbol", "futbol", "sports":
            return "figure.run"
        case "pi-palette", "palette", "workshop":
            return "person.crop.rectangle"
        case "pi-globe", "globe", "happy":
            return "wineglass"
        case "pi-apple", "apple", "wellness":
            return "heart.fill"
        case "pi-building", "building", "team":
            return "building.2.fill"
        default:
            return "tag.fill"
        }
    }
}

