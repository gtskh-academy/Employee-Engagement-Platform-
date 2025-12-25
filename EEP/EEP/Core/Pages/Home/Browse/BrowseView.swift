//
//  BrowseView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import SwiftUI

struct BrowseView: View {
    
    @State private var selectedLocation: String = "Location"
    @State private var showLastWeek = false
    @State var search: String = ""
    
    private let events = EventModel.dummyEvents
    
    private var locations: [String] {
        Array(Set(events.map { $0.location })).sorted()
    }
    
    private var filteredEvents: [EventModel] {
        events.filter {
            (selectedLocation == "Location" || $0.location == selectedLocation) &&
            (!showLastWeek || $0.isLastWeek)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                filterSection
                
                ForEach(filteredEvents) { event in
                    EventCardView(event: event)
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
    
    private var filterSection: some View {
        VStack {
            HStack {
                    TextField("Search events", text: $search)
                        .padding(.leading, 12)
                        .padding(.vertical, 10)
                    
                    Spacer()
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.trailing, 12)
                }
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)
                .padding(.bottom,10)
            HStack(spacing: 12) {
                Button(action: {
                    
                }, label: {
                    HStack {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 13,height: 13)
                        Text("Filter")
                            .foregroundStyle(.white)
                        
                    }
                    .padding(.horizontal,20)
                    .padding(.vertical,5)
                    .background(Color.black)
                    .cornerRadius(40)
                })
                
                Menu {
                    ForEach(locations, id: \.self) { location in
                        Button(location) {
                            selectedLocation = location
                        }
                    }
                } label: {
                    filterChip(title: selectedLocation)
                }
                
                Button {
                    showLastWeek.toggle()
                } label: {
                    filterChip(title: showLastWeek ? "Last Week ✓" : "Last Week")
                }
                
                Spacer()
            }
        }
    }
    
    private func filterChip(title: String) -> some View {
        HStack {
            Text(title)
            Image(systemName: "chevron.down")
        }
        .font(.caption)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(20)
    }
}


#Preview {
    BrowseView()
}
