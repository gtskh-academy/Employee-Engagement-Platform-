//
//  HomeView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    let columns: [GridItem] = [
         GridItem(.flexible(), spacing: 16),
         GridItem(.flexible(), spacing: 16),
         GridItem(.flexible(), spacing: 16)
     ]
    
    var body: some View {
        NavigationStack {
            VStack {
                HomeHeader()
                    .padding()
                    .background(Color(.systemBackground))
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Welcome Back, \(viewModel.currentUser?.firstName ?? "User")")
                            .font(.title)
                        Text("Stay connected with upcoming company events and activities.")
                            .foregroundStyle(.black.opacity(0.7))
                        Spacer()
                            .frame(height: 40)
                        HStack {
                            Text("Upcoming Events")
                                .font(.title2)
                            Spacer()
                            Button(action: {
                                viewModel.showAllEventsSheet = true
                            }) {
                                Text("View all")
                                    .foregroundColor(.black)
                            }
                        }
                        VStack {
                            if viewModel.isLoadingMyEvents {
                                HStack {
                                    ProgressView()
                                    Text("Loading events...")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            } else if let error = viewModel.myEventsError {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding()
                            } else if let firstEvent = viewModel.myEvents.first {
                                MyEventCardView(event: firstEvent)
                            } else {
                                Text("No upcoming events")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("Browse By Category")
                                .font(.title2)
                            if viewModel.isLoadingCategories {
                                HStack {
                                    ProgressView()
                                    Text("Loading categories...")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            } else if let error = viewModel.categoriesError {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding()
                            } else if viewModel.categories.isEmpty {
                                Text("No categories available")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(viewModel.categories) { category in
                                        CategoryCardView(category: category)
                                    }
                                }
                            }
                        }
                        .padding(.bottom,20)
                        VStack(alignment: .leading) {
                            Text("Trending Events")
                                .font(.title2)
                            Text("Popular events with high registration rates")
                            if viewModel.isLoading {
                                HStack {
                                    ProgressView()
                                    Text("Loading...")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            } else if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding()
                            } else if viewModel.trendingEvents.isEmpty {
                                Text("No trending events available at the moment.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 16) {
                                        ForEach(viewModel.trendingEvents) { event in
                                            PopularEventCardView(event: event)
                                        }
                                    }
                                }
                            }
                        }
                        VStack(alignment: .leading) {
                            Text("Frequently Asked Questions")
                                .font(Font.title2)
                                .padding(.bottom,10)
                            Text("What if I need to cancel?").font(.title3)
                            Text("You can cancel your registration up to 24 hours before the event through this app. This will allow someone from the waitlist to attend.").font(.footnote)
                        }
                    }.padding(.horizontal,15)
                }.scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
            .padding(.bottom,40)
            .onAppear {
                viewModel.loadTrendingEvents()
                viewModel.loadCurrentUser()
                viewModel.loadMyEvents()
                viewModel.loadCategories()
            }
            .sheet(isPresented: $viewModel.showAllEventsSheet) {
                AllMyEventsView(events: viewModel.myEvents)
            }
        }
    }
}
