//
//  NotificationRefreshManager.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

extension Notification.Name {
    static let shouldRefreshNotifications = Notification.Name("shouldRefreshNotifications")
}

class NotificationRefreshManager {
    static let shared = NotificationRefreshManager()
    
    private init() {}
    
    func postRefreshNotification() {
        NotificationCenter.default.post(name: .shouldRefreshNotifications, object: nil)
    }
}

