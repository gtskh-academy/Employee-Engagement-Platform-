//
//  EventsViewMode.swift
//  EEP
//
//  Created by m1 pro on 24.12.25.
//



import SwiftUI

struct MyEventsHeaderView: View {
    @State private var selectedMode: EventsViewMode = .calendar
    var events = Event.array
    var body: some View {
        VStack {
            Text("My Event")
                .font(.title)
           
            Picker("View Mode", selection: $selectedMode) {
               ForEach(EventsViewMode.allCases) { mode in
                    Text(mode.rawValue)
                    .tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 10)
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 400, height: 2)
            VStack(alignment: .leading) {
                Text("Next Upcoming Events")
                    .font(.callout)
                    .foregroundStyle(.black.opacity(0.6))
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.08))
                        .frame(width: 370, height: 250)
                        .cornerRadius(10)
                    VStack(alignment: .leading,spacing: 5) {
                        Text(events[0].title)
                            .font(.title3)
                        HStack(spacing: 5) {
                            Image("Event")
                            Text(events[0].month)
                            Text("\(events[0].day),")
                            Text("\(events[0].year),")
                            Text("AM \(events[0].startTime) - PM \(events[0].endTime),")
                        }
                        HStack {
                            Image("map")
                                .resizable()
                                .frame(width: 10,height: 10)
                            Text(events[0].location)
                        }
                        ZStack {
                            Rectangle()
                                .fill(.gray.opacity(0.5))
                                .frame(width: 350, height: 140)
                                .cornerRadius(10)
                            Text("Map Preview of Event Location")
                        }
                        }.font(.footnote)
                }
            }
        }
    }
}


enum EventsViewMode: String, CaseIterable, Identifiable {
    case list = "List"
    case calendar = "Calendar"
    
    var id: String { rawValue }
}


#Preview {
    MyEventsView()
}
