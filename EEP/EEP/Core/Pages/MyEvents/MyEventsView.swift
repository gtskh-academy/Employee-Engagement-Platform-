//
//  MyEventsView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import SwiftUI

struct MyEventsView: View {
    var events = Event.array
    @State private var selectedDates: Set<DateComponents> = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                MyEventsHeaderView()
                    .padding(.bottom, 20)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 400, height: 2)
                
                MultiDatePicker(
                    "Select Date",
                    selection: $selectedDates
                )
                .frame(width: 350)
                .padding()
                
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 400, height: 2)
                
                Text("Events on Tuesday, Dec 16")
                    .font(.title2)
                    .foregroundStyle(.black.opacity(0.6))
                    .padding(.trailing,120)
                ForEach(events) { event in
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 350, height: 120)
                            .cornerRadius(10)
                        
                        HStack(spacing: 20) {

                            // TIME COLUMN (fixed width)
                            VStack {
                                Text(event.startTime)
                                Text("AM")
                            }
                            .frame(width: 50)
                            .padding(.leading,10)
                            .padding(.bottom,40)

                            Rectangle()
                                .fill(Color.black.opacity(0.7))
                                .frame(width: 2, height: 100)
                                .fixedSize()

                            VStack(alignment: .leading, spacing: 6) {
                                Text(event.title)
                                    .lineLimit(2)
                                    .truncationMode(.tail)

                                HStack {
                                    Image(systemName: "rectangle.badge.person.crop")
                                        .resizable()
                                        .frame(width: 18, height: 15)
                                    Text(event.eventCategory)
                                        .font(.footnote)
                                }

                                Text(event.location)
                                    .font(.footnote)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                            .padding(.bottom,30)
                        }
                        .frame(width: 350) 
                    }
                }
            }
            .padding(.vertical)
        }
    }
}


#Preview {
    MyEventsView()
}
