//
//  TabSelectionManager.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation
import SwiftUI

class TabSelectionManager: ObservableObject {
    @Published var selectedTab: Int = 0
    
    static let shared = TabSelectionManager()
}

