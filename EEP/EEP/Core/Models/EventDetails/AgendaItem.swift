//
//  AgendaItem.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct AgendaItem: Identifiable {
    let id = UUID()
    let number: Int
    let time: String
    let title: String
    let description: String?
    let location: String?
}

