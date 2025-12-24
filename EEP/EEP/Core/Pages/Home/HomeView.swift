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
    @State var eventArray = Event.array
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
                            Text("View all")
                        }
                        VStack {
                            ForEach(eventArray) { array in
                                ZStack {
                                    Rectangle()
                                        .fill(.gray.opacity(0.1))
                                        .frame(height: 180)
                                        .cornerRadius(10)
                                    
                                    HStack(spacing: 40) {
                                        VStack {
                                            Text(array.month).foregroundStyle(.black.opacity(0.7))
                                            Text("\(array.day)").font(.title)
                                        }.padding(.bottom,70)
                                            .padding(.leading)
                                        VStack(alignment: .leading,spacing: 12) {
                                            Text(array.title).font(.title3)
                                            HStack {
                                                Image("time").resizable().frame(width: 10,height: 10)
                                                Text("\(array.startTime)- \(array.endTime)").font(.footnote)
                                                Image("map").resizable().frame(width: 10,height: 10)
                                                Text("\(array.location)").font(.footnote)
                                            }
                                            Text(array.description).font(.caption2)
                                                .lineLimit(3)
                                                .padding(.trailing,100)
                                            HStack(spacing: 5) {
                                                Image("people")
                                                    .resizable()
                                                    .frame(width: 10,height: 10)
                                                Text("\(array.registeredCount) registered").font(.footnote)
                                                Spacer()
                                                    .frame(width: 50)
                                                Text("View Details →")
                                            }
                                        }
                                    }
                                }
                                
                            }
                            
                            
                        }
                        VStack(alignment: .leading) {
                            Text("Broswe By Category")
                                .font(.title2)
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(Category.mock) { category in
                                    CategoryCardView(category: category)
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
            }
        }
    }
}

#Preview {
    HomeView()
}
