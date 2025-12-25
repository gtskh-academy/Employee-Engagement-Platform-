//
//  NotificationService.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct NotificationService {
    static let shared = NotificationService()
    
    private let baseURL = URL(string: "http://34.52.231.181:8080")!
    
    func getNotifications(pageNumber: Int = 1, pageSize: Int = 10) async throws -> NotificationResponse {
        guard let token = TokenManager.shared.token else {
            throw NetworkError.serverError("Not authenticated")
        }
        
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent("/api/Notifications"), resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "pageNumber", value: "\(pageNumber)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)")
        ]
        
        guard let url = urlComponents.url else {
            throw NetworkError.serverError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            do {
                let notificationResponse = try decoder.decode(NotificationResponse.self, from: data)
                return notificationResponse
            } catch {
                throw NetworkError.serverError("Failed to parse response: \(error.localizedDescription)")
            }
        case 401:
            throw NetworkError.serverError("Unauthorized - please sign in again")
        default:
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(message)
        }
    }
    
    func markAsRead(notificationId: Int) async throws {
        guard let token = TokenManager.shared.token else {
            throw NetworkError.serverError("Not authenticated")
        }
        
        let url = baseURL.appendingPathComponent("/api/Notifications/\(notificationId)/read")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return
        case 401:
            throw NetworkError.serverError("Unauthorized - please sign in again")
        default:
            let message = "Failed to mark notification as read"
            throw NetworkError.serverError(message)
        }
    }
}

