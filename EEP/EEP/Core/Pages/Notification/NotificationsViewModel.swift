//
//  NotificationsViewModel.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation
import SwiftUI

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [UserNotification] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedTab: NotificationType = .all
    @Published var currentPage: Int = 1
    @Published var hasMorePages: Bool = false
    @Published var isLoadingMore: Bool = false
    
    private let pageSize = 10
    
    var filteredNotifications: [UserNotification] {
        if selectedTab == .all {
            return notifications
        }
        return notifications.filter { $0.notificationType == selectedTab }
    }
    
    var newNotifications: [UserNotification] {
        filteredNotifications.filter { !$0.isRead }
    }
    
    var earlierNotifications: [UserNotification] {
        filteredNotifications.filter { $0.isRead }
    }
    
    func loadNotifications() {
        isLoading = true
        errorMessage = nil
        currentPage = 1
        
        Task {
            do {
                let response = try await NotificationService.shared.getNotifications(pageNumber: currentPage, pageSize: pageSize)
                await MainActor.run {
                    self.notifications = response.notifications
                    self.hasMorePages = response.pageNumber < response.totalPages
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .serverError(let message):
                            self.errorMessage = message
                        case .invalidResponse:
                            self.errorMessage = "Invalid response from server"
                        }
                    } else {
                        self.errorMessage = "Failed to load notifications: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    func loadMoreNotifications() {
        guard !isLoadingMore && hasMorePages else { return }
        
        isLoadingMore = true
        let nextPage = currentPage + 1
        
        Task {
            do {
                let response = try await NotificationService.shared.getNotifications(pageNumber: nextPage, pageSize: pageSize)
                await MainActor.run {
                    self.notifications.append(contentsOf: response.notifications)
                    self.currentPage = nextPage
                    self.hasMorePages = response.pageNumber < response.totalPages
                    self.isLoadingMore = false
                }
            } catch {
                await MainActor.run {
                    self.isLoadingMore = false
                }
            }
        }
    }
    
    func refreshNotifications() {
        loadNotifications()
    }
    
    func markAsRead(notificationId: Int) {
        if let index = notifications.firstIndex(where: { $0.id == notificationId }) {
            notifications[index].isRead = true
        }
        
        Task {
            do {
                try await NotificationService.shared.markAsRead(notificationId: notificationId)
            } catch {
                await MainActor.run {
                    if let index = self.notifications.firstIndex(where: { $0.id == notificationId }) {
                        self.notifications[index].isRead = false
                    }
                }
            }
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(
            forName: .shouldRefreshNotifications,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.refreshNotifications()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

