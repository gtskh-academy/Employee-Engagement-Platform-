//
//  BrowseView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import SwiftUI

struct BrowseView: View {
    let categoryId: Int?
    let categoryName: String?
    
    @StateObject private var viewModel: HomeBrowseViewModel
    
    init(categoryId: Int?, categoryName: String?) {
        self.categoryId = categoryId
        self.categoryName = categoryName
        _viewModel = StateObject(wrappedValue: HomeBrowseViewModel(selectedCategoryId: categoryId))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        TextField("Search events", text: $viewModel.searchText)
                            .padding(.leading, 12)
                            .padding(.vertical, 10)
                        
                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.trailing, 12)
                    }
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if viewModel.isLoading {
                        VStack(spacing: 12) {
                            ProgressView()
                            Text("Loading events...")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 100)
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.red)
                            Text("Error")
                                .font(.title2)
                                .foregroundColor(.red)
                            Text(error)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 100)
                        .padding(.horizontal)
                    } else if viewModel.filteredEvents.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                            Text("No Events")
                                .font(.title2)
                                .foregroundColor(.gray)
                            Text(viewModel.searchText.isEmpty
                                 ? "No events available in this category."
                                 : "No events match your search.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 100)
                        .padding(.horizontal)
                    } else {
                        ForEach(viewModel.filteredEvents) { event in
                            NavigationLink(destination: EventDetailView(eventId: event.id)) {
                                BrowseEventCardView(event: event)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle(categoryName ?? "Browse Events")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadEvents()
            }
        }
    }
}
