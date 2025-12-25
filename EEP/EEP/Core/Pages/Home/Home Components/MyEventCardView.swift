//
//  MyEventCardView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import SwiftUI

struct MyEventCardView: View {
    let event: MyEvent
    @State private var showEventDetail = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray.opacity(0.1))
                .frame(height: 180)
                .cornerRadius(10)
            
            HStack(spacing: 40) {
                VStack {
                    Text(event.month)
                        .foregroundStyle(.black.opacity(0.7))
                    Text("\(event.day)")
                        .font(.title)
                }
                .padding(.bottom, 70)
                .padding(.leading)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(event.title)
                        .font(.title3)
                    
                    HStack {
                        Image("time")
                            .resizable()
                            .frame(width: 10, height: 10)
                        Text("\(event.startTime)-\(event.endTime)")
                            .font(.footnote)
                        Image("map")
                            .resizable()
                            .frame(width: 10, height: 10)
                        Text(event.locationString)
                            .font(.footnote)
                    }
                    
                    Text(event.descriptionText)
                        .font(.caption2)
                        .lineLimit(2)
                        .padding(.trailing, 100)
                    
                    HStack(spacing: 5) {
                        Image("people")
                            .resizable()
                            .frame(width: 10, height: 10)
                        Text("\(event.confirmedCount ?? 0) registered")
                            .font(.footnote)
                        Spacer()
                            .frame(width: 50)
                        Button(action: {
                            showEventDetail = true
                        }) {
                            Text("View Details →")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showEventDetail) {
            EventDetailView(event: event)
        }
    }
}

