//
//  EventsService.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct EventsService {
    static let shared = EventsService()
    
    private let baseURL = URL(string: "http://34.52.231.181:8080")!
    
    func getTrendingEvents() async throws -> [TrendingEvent] {
        guard let token = TokenManager.shared.token else {
            throw NetworkError.serverError("Not authenticated")
        }
        
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/Events/trending"))
        request.httpMethod = "GET"
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            // Debug: Print raw response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Trending Events Response: \(jsonString)")
            }
            
            let decoder = JSONDecoder()
            do {
                let events = try decoder.decode([TrendingEvent].self, from: data)
                return events
            } catch {
                // More detailed error logging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Failed to parse JSON: \(jsonString)")
                }
                print("Decoding error: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("Missing key: \(key.stringValue) at \(context.codingPath)")
                    case .typeMismatch(let type, let context):
                        print("Type mismatch: expected \(type) at \(context.codingPath)")
                    case .valueNotFound(let type, let context):
                        print("Value not found: \(type) at \(context.codingPath)")
                    case .dataCorrupted(let context):
                        print("Data corrupted at \(context.codingPath): \(context.debugDescription)")
                    @unknown default:
                        print("Unknown decoding error")
                    }
                }
                throw NetworkError.serverError("Failed to parse response: \(error.localizedDescription)")
            }
        case 401:
            throw NetworkError.serverError("Unauthorized - please sign in again")
        default:
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(message)
        }
    }
}

