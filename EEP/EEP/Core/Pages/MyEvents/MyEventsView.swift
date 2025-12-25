//
//  MyEventsView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import SwiftUI

struct MyEventsView: View {
    @StateObject private var viewModel = MyEventsViewModel()
    @State private var selectedMode: EventsViewMode = .list
    @State private var selectedDate: Date = Date()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                MyEventsHeaderView(selectedMode: $selectedMode)
                    .padding(.bottom, 20)
                
                if selectedMode == .list {
                    listView
                } else {
                    calendarView
                }
            }
            .padding(.vertical)
        }
        .onAppear {
            viewModel.loadEvents()
        }
    }
    
    @ViewBuilder
    private var listView: some View {
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
        } else if viewModel.events.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "calendar.badge.exclamationmark")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
                Text("No Events")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text("You haven't registered for any events yet.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 100)
        } else {
            VStack(spacing: 16) {
                ForEach(viewModel.events) { event in
                    MyEventListItemView(event: event)
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var calendarView: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let firstEvent = viewModel.events.first {
                VStack(alignment: .leading) {
                    Text("Next Upcoming Events")
                        .font(.callout)
                        .foregroundStyle(.black.opacity(0.6))
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.08))
                            .frame(width: 370, height: 250)
                            .cornerRadius(10)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(firstEvent.title)
                                .font(.title3)
                            HStack(spacing: 5) {
                                Image("Event")
                                Text(firstEvent.month)
                                Text("\(firstEvent.day),")
                                Text("\(firstEvent.year),")
                                Text("\(firstEvent.startTime) - \(firstEvent.endTime),")
                            }
                            HStack {
                                Image("map")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                Text(firstEvent.locationString)
                            }
                            
                            mapView(for: firstEvent.location)
                        }
                        .font(.footnote)
                    }
                }
                .padding(.horizontal)
            }
            
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 400, height: 2)
            
            CustomCalendarView(
                selectedDate: $selectedDate,
                eventDates: viewModel.getEventDates()
            )
            .padding()
            
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 400, height: 2)
            
            let selectedDateEvents = viewModel.getEvents(for: selectedDate)
            if !selectedDateEvents.isEmpty {
                Text("Events on \(viewModel.getFormattedDateString(for: selectedDate))")
                    .font(.title3)
                    .foregroundStyle(.black.opacity(0.6))
                    .padding(.leading)
                    .padding(.trailing, 120)
                
                EventDayListView(events: selectedDateEvents)
                    .padding(.leading)
            } else {
                Text("Events on \(viewModel.getFormattedDateString(for: selectedDate))")
                    .font(.title3)
                    .foregroundStyle(.black.opacity(0.6))
                    .padding(.leading)
                    .padding(.trailing, 120)
                
                Text("No events on this date")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.leading)
                    .padding(.vertical)
            }
        }
    }
    
    @ViewBuilder
    private func mapView(for location: EventLocation?) -> some View {
        if let location = location {
            let addressString = buildAddressString(from: location)
            if !addressString.isEmpty {
                EventMapView(address: addressString)
            } else {
                placeholderMapView
            }
        } else {
            placeholderMapView
        }
    }
    
    private func buildAddressString(from location: EventLocation) -> String {
        var addressString = ""
        if let address = location.address, !address.isEmpty {
            addressString = address
            if let city = location.city, !city.isEmpty {
                addressString += ", \(city)"
            }
        } else if let venueName = location.venueName, !venueName.isEmpty {
            addressString = venueName
            if let city = location.city, !city.isEmpty {
                addressString += ", \(city)"
            }
        } else if let city = location.city, !city.isEmpty {
            addressString = city
        }
        return addressString
    }
    
    @ViewBuilder
    private var placeholderMapView: some View {
        ZStack {
            Rectangle()
                .fill(.gray.opacity(0.5))
                .frame(width: 350, height: 140)
                .cornerRadius(10)
            Text("Map Preview of Event Location")
        }
    }
}
