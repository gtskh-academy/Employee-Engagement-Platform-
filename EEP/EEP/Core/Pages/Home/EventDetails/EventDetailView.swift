//
//  EventDetailView.swift
//  EEP
//
//  Created by m1 pro on 24.12.25.
//


import SwiftUI

struct EventDetailView: View {
    @StateObject private var viewModel: EventDetailViewModel
    @State private var showRegistrationAlert = false
    private let shouldDisableRegister: Bool
    
    init(event: MyEvent) {
        _viewModel = StateObject(wrappedValue: EventDetailViewModel(event: event, shouldFetchDetails: false))
        self.shouldDisableRegister = true // Disable when opened from home page
    }
    
    init(eventId: Int) {
        _viewModel = StateObject(wrappedValue: EventDetailViewModel(eventId: eventId))
        self.shouldDisableRegister = false // Enable when opened from BrowseByCategory
    }
    
    private var showErrorAlert: Bool {
        viewModel.errorMessage != nil
    }
    
    private var eventHeader: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 200)
            .overlay(
                Text("Event Banner Image")
                    .foregroundColor(.white)
            )
    }
    
    @ViewBuilder
    private var eventInfoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 8) {
                if let categoryName = viewModel.categoryName {
                    TagView(text: categoryName, background: .gray.opacity(0.2))
                }
                
                if let myStatus = viewModel.myStatus {
                    TagView(text: myStatus, background: .black)
                }
            }
            .padding(.top, 16)
            
            Text(viewModel.event.title)
                .font(.title2)
                .bold()
            
            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text(viewModel.formattedDate)
                    .font(.subheadline)
            }
            
            HStack(spacing: 12) {
                Image(systemName: "clock")
                    .foregroundColor(.gray)
                Text(viewModel.timeRange)
                    .font(.subheadline)
            }
            
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle")
                    .foregroundColor(.gray)
                Text(viewModel.locationString)
                    .font(.subheadline)
            }
            
            HStack(spacing: 12) {
                Image(systemName: "person.2")
                    .foregroundColor(.gray)
                Text("\(viewModel.registeredCount) registered, \(viewModel.spotsLeft) spots left")
                    .font(.subheadline)
            }
            
            CommonButton(title: shouldDisableRegister ? "Confirmed" : "Register Now") {
                if !shouldDisableRegister {
                    showRegistrationAlert = true
                }
            }
            .disabled(shouldDisableRegister)
            .padding(.top, 8)
            
            Text("Registration closes on Dec 19, 2025 at 5:00 PM.")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 1)
            
            Divider()
                .padding(.vertical, 8)
            
            Text("About this event")
                .font(.headline)
            
            Text(viewModel.descriptionText)
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.7))
                .lineSpacing(4)
                .padding(.top, 4)
        }
    }
    
    private var agendaSection: some View {
        Group {
            if viewModel.hasAgenda {
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                        .padding(.vertical, 8)
                    
                    Text("Agenda")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(Array(viewModel.agendaItems.enumerated()), id: \.element.id) { index, item in
                            HStack(alignment: .top, spacing: 12) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 32, height: 32)
                                        Text("\(item.number)")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }
                                    
                                    if index < viewModel.agendaItems.count - 1 {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 2, height: 40)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(item.time) - \(item.title)")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    if let description = item.description, !description.isEmpty {
                                        Text(description)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .lineSpacing(3)
                                    }
                                    
                                    if let location = item.location, !location.isEmpty {
                                        Text(location)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
    }
    
    private var speakersSection: some View {
        Group {
            if viewModel.hasSpeakers {
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                        .padding(.vertical, 8)
                    
                    Text("Featured Speakers")
                        .font(.headline)
                    
                    VStack(spacing: 16) {
                        ForEach(viewModel.speakers) { speaker in
                            SpeakerView(
                                name: speaker.name,
                                title: speaker.role
                            )
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
    }
    
    private var loadingOverlay: some View {
        Group {
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    eventHeader
                    
                    VStack(alignment: .leading, spacing: 20) {
                        eventInfoSection
                        agendaSection
                        speakersSection
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("Event Details")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if viewModel.shouldFetchDetails {
                viewModel.loadEventDetails()
            }
        }
        .overlay(loadingOverlay)
        .alert("Error", isPresented: .constant(showErrorAlert)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
        .alert("Registration", isPresented: $showRegistrationAlert) {
            Button("OK") {
            }
        } message: {
            Text("Registration functionality will be implemented soon.")
        }
    }
}
