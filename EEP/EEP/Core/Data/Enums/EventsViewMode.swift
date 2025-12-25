//
//  EventsViewMode.swift
//  EEP
//
//  Created by m1 pro on 24.12.25.
//

import Foundation

enum EventsViewMode: String, CaseIterable, Identifiable {
    case list = "List"
    case calendar = "Calendar"
    
    var id: String { rawValue }
}

