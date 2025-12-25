//
//  EventDetailSheet.swift
//  EEP
//
//  Created by m1 pro on 25.12.25.
//

import SwiftUI
import Foundation

struct EventDetailSheet: View {
    let event: EventDetails
    @Environment(\.dismiss) var dismiss
    @State private var isCancelling = false
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(event.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 20)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        Text(event.dateTime)
                            .foregroundColor(.primary)
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.circle")
                            .foregroundColor(.gray)
                        Text(event.location)
                            .foregroundColor(.primary)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    VStack(spacing: 16) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.primary)
                                Text("Send a question about the event")
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "calendar.badge.plus")
                                    .foregroundColor(.primary)
                                Text("Add to my calendar")
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    
                    Spacer(minLength: 20)
                    
                    HStack {
                        Spacer()
                        CommonButton(title: isCancelling ? "Cancelling..." : "Cancel Registration") {
                            cancelRegistration()
                        }
                        .disabled(isCancelling)
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Close")
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
        .alert("Registration Cancelled", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your registration has been successfully cancelled.")
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            if let error = errorMessage {
                Text(error)
            }
        }
    }
    
    private func cancelRegistration() {
        guard let registrationId = event.registrationId else {
            errorMessage = "Registration ID not available. Please try refreshing or contact support."
            showErrorAlert = true
            return
        }
        
        isCancelling = true
        errorMessage = nil
        
        Task {
            do {
                try await EventsService.shared.cancelRegistration(registrationId: registrationId)
                await MainActor.run {
                    self.isCancelling = false
                    self.showSuccessAlert = true
                    NotificationRefreshManager.shared.postRefreshNotification()
                }
            } catch {
                await MainActor.run {
                    self.isCancelling = false
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .serverError(let message):
                            self.errorMessage = message
                        case .invalidResponse:
                            self.errorMessage = "Invalid response from server"
                        }
                    } else {
                        self.errorMessage = "Failed to cancel registration: \(error.localizedDescription)"
                    }
                    self.showErrorAlert = true
                }
            }
        }
    }
}
