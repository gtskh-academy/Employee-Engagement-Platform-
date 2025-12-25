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
            let decoder = JSONDecoder()
            do {
                let events = try decoder.decode([TrendingEvent].self, from: data)
                return events
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
    
    func getMyEvents() async throws -> [MyEvent] {
        guard let token = TokenManager.shared.token else {
            throw NetworkError.serverError("Not authenticated")
        }
        
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/Events/me"))
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
                let events = try decoder.decode([MyEvent].self, from: data)
                return events
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
    
    func getCategories() async throws -> [EventCategoryModel] {
        guard let token = TokenManager.shared.token else {
            throw NetworkError.serverError("Not authenticated")
        }
        
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/Events/categories"))
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
                let categories = try decoder.decode([EventCategoryModel].self, from: data)
                return categories
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
    
    func getEvents() async throws -> [BrowseEvent] {
        guard let token = TokenManager.shared.token else {
            throw NetworkError.serverError("Not authenticated")
        }
        
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/Events"))
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
                let events = try decoder.decode([BrowseEvent].self, from: data)
                return events
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
    
    func getEventById(_ eventId: Int) async throws -> MyEvent {
        guard let token = TokenManager.shared.token else {
            throw NetworkError.serverError("Not authenticated")
        }
        
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/Events/\(eventId)"))
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
                let event = try decoder.decode(MyEvent.self, from: data)
                return event
            } catch {
                throw NetworkError.serverError("Failed to parse response: \(error.localizedDescription)")
            }
        case 401:
            throw NetworkError.serverError("Unauthorized - please sign in again")
        case 404:
            throw NetworkError.serverError("Event not found")
        default:
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(message)
        }
    }
    
    func registerForEvent(eventId: Int) async throws -> RegistrationResponse {
        guard let token = TokenManager.shared.token else {
            throw NetworkError.serverError("Not authenticated")
        }
        
        let url = baseURL.appendingPathComponent("/api/Registrations")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let registrationRequest = RegistrationRequest(eventId: eventId)
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(registrationRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            do {
                let registrationResponse = try decoder.decode(RegistrationResponse.self, from: data)
                return registrationResponse
            } catch {
                throw NetworkError.serverError("Failed to parse response: \(error.localizedDescription)")
            }
        case 401:
            throw NetworkError.serverError("Unauthorized - please sign in again")
        case 400:
            throw NetworkError.serverError("Invalid request - event may be full or registration closed")
        default:
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(message)
        }
    }
    
    func cancelRegistration(registrationId: Int) async throws {
        guard let token = TokenManager.shared.token else {
            throw NetworkError.serverError("Not authenticated")
        }
        
        let url = baseURL.appendingPathComponent("/api/Registrations/\(registrationId)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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
        case 404:
            throw NetworkError.serverError("Registration not found")
        default:
            throw NetworkError.serverError("Failed to cancel registration")
        }
    }
    
    func getRegistrationId(for eventId: Int) async throws -> Int? {
        guard let token = TokenManager.shared.token else {
            throw NetworkError.serverError("Not authenticated")
        }
        
        do {
            let url = baseURL.appendingPathComponent("/api/Registrations")
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("text/plain", forHTTPHeaderField: "accept")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                let decoder = JSONDecoder()
                do {
                    let registrations = try decoder.decode([RegistrationResponse].self, from: data)
                
                    if let registration = registrations.first(where: { $0.eventId == eventId && $0.cancelledAt == nil }) {
                        return registration.id
                    }
                } catch {
                }
            }
        } catch {
        }
        
        do {
            let myEvents = try await getMyEvents()
           
            if myEvents.contains(where: { $0.eventId == eventId }) {
                let url = baseURL.appendingPathComponent("/api/Registrations")
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("text/plain", forHTTPHeaderField: "accept")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse,
                   (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
                    let decoder = JSONDecoder()
                    if let registrations = try? decoder.decode([RegistrationResponse].self, from: data) {
                        if let registration = registrations.first(where: { $0.eventId == eventId && $0.cancelledAt == nil }) {
                            return registration.id
                        }
                    }
                }
            }
        } catch {
        }
        
        return nil
    }
}

