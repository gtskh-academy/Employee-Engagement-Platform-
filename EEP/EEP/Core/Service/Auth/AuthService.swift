//
//  AuthService.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct AuthService {
    static let shared = AuthService()
    
    private let baseURL = URL(string: "http://34.52.231.181:8080")!
    
    func register(_ requestBody: RegisterRequest) async throws -> RegisterResponse {
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/Auth/register"))
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        request.setValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            // Parse JSON response
            let decoder = JSONDecoder()
            do {
                let registerResponse = try decoder.decode(RegisterResponse.self, from: data)
                return registerResponse
            } catch {
                throw NetworkError.serverError("Failed to parse response: \(error.localizedDescription)")
            }
        case 400:
            let errorMessage = String(data: data, encoding: .utf8) ?? "Bad request"
            throw NetworkError.serverError(errorMessage)
        default:
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(message)
        }
    }
    
    func login(_ requestBody: LoginRequest) async throws -> RegisterResponse {
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/Auth/login"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            // Parse JSON response
            let decoder = JSONDecoder()
            do {
                let loginResponse = try decoder.decode(RegisterResponse.self, from: data)
                return loginResponse
            } catch {
                throw NetworkError.serverError("Failed to parse response: \(error.localizedDescription)")
            }
        case 400, 401:
            let errorMessage = String(data: data, encoding: .utf8) ?? "Invalid email or password"
            throw NetworkError.serverError(errorMessage)
        default:
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(message)
        }
    }
    
    func sendPhoneCode(_ requestBody: SendPhoneCodeRequest) async throws {
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/Auth/send-phone-code"))
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            // Success - OTP sent
            return
        case 400:
            let errorMessage = String(data: data, encoding: .utf8) ?? "Bad request"
            throw NetworkError.serverError(errorMessage)
        default:
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(message)
        }
    }
    
    func verifyPhone(_ requestBody: VerifyPhoneRequest) async throws {
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/Auth/verify-phone"))
        request.httpMethod = "POST"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("application/json-patch+json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            // Success - Phone verified
            return
        case 400:
            let errorMessage = String(data: data, encoding: .utf8) ?? "Invalid code"
            throw NetworkError.serverError(errorMessage)
        default:
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(message)
        }
    }
    
    func getCurrentUser() async throws -> User {
        guard let token = TokenManager.shared.token else {
            throw NetworkError.serverError("Not authenticated")
        }
        
        var request = URLRequest(url: baseURL.appendingPathComponent("/api/Auth/me"))
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
                let user = try decoder.decode(User.self, from: data)
                // Update TokenManager with the fetched user data
                TokenManager.shared.currentUser = user
                return user
            } catch {
                throw NetworkError.serverError("Failed to parse response: \(error.localizedDescription)")
            }
        case 401:
            throw NetworkError.serverError("Unauthorized")
        default:
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(message)
        }
    }
    
    func getDepartments(onlyActive: Bool = true) async throws -> [Department] {
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent("/api/Departments"), resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [URLQueryItem(name: "onlyActive", value: "\(onlyActive)")]
        
        guard let url = urlComponents.url else {
            throw NetworkError.serverError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("text/plain", forHTTPHeaderField: "accept")
        
        // Add token if available (for authenticated requests)
        if let token = TokenManager.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            do {
                let departments = try decoder.decode([Department].self, from: data)
                return departments
            } catch {
                throw NetworkError.serverError("Failed to parse response: \(error.localizedDescription)")
            }
        case 401:
            throw NetworkError.serverError("Unauthorized")
        default:
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NetworkError.serverError(message)
        }
    }
}


