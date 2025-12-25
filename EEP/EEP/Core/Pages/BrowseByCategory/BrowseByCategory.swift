//
//  BrowseByCategory.swift
//  EEP
//
//  Created by m1 pro on 25.12.25.
//


import SwiftUI


struct BrowseByCategory: View {
    @StateObject private var viewModel = BrowseViewModel()
    let itemHeight: CGFloat = 40
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
            BrowseViewHeaderEvent(searchText: $viewModel.searchText)
                .padding(.bottom, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    Button(action: {
                        viewModel.selectCategory(nil)
                    }, label: {
                        Text("All")
                            .foregroundStyle(viewModel.selectedCategoryId == nil ? .white : .black)
                            .frame(width: 50, height: 40)
                            .background(viewModel.selectedCategoryId == nil ? Color.black : Color.gray.opacity(0.3))
                            .cornerRadius(20)
                    })
                    
                    if viewModel.isLoadingCategories {
                        ProgressView()
                            .frame(height: itemHeight)
                    } else {
                        ForEach(viewModel.categories) { category in
                            Button(action: {
                                viewModel.selectCategory(category.id)
                            }, label: {
                                Text(category.name)
                                    .font(.footnote)
                                    .foregroundStyle(viewModel.selectedCategoryId == category.id ? .white : .black)
                                    .padding(.horizontal, 12)
                                    .frame(height: itemHeight)
                                    .background(viewModel.selectedCategoryId == category.id ? Color.black : Color.gray.opacity(0.3))
                                    .cornerRadius(20)
                            })
                        }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: itemHeight + 10)
            
            ScrollView {
                if viewModel.isLoadingEvents {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Loading events...")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 100)
                } else if let error = viewModel.eventsError {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.red)
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 100)
                } else if viewModel.filteredEvents.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                        Text("No Events")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text(viewModel.selectedCategoryId != nil || !viewModel.searchText.isEmpty
                             ? "No events match your filters."
                             : "No events available.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 100)
                } else {
                    ForEach(viewModel.filteredEvents) { event in
                        NavigationLink(destination: EventDetailView(eventId: event.id)) {
                            BrowseEventCardView(event: event)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .onAppear {
            viewModel.loadEvents()
            viewModel.loadCategories()
        }
        }
    }
}
