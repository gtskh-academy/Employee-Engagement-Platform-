//
//  EventDayListView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import SwiftUI

struct EventDayListView: View {
    let events: [MyEvent]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(events) { event in
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 350, height: 120)
                        .cornerRadius(10)
                    
                    HStack(spacing: 20) {
                        // TIME COLUMN (fixed width)
                        timeColumnView(for: event)
                            .frame(width: 50)
                            .padding(.leading, 10)
                            .padding(.bottom, 40)
                        
                        Rectangle()
                            .fill(Color.black.opacity(0.7))
                            .frame(width: 2, height: 100)
                            .fixedSize()
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(event.title)
                                .font(.system(size: 16, weight: .medium))
                                .lineLimit(2)
                                .truncationMode(.tail)
                            
                            HStack {
                                Image(systemName: "rectangle.badge.person.crop")
                                    .resizable()
                                    .frame(width: 18, height: 15)
                                    .foregroundColor(.gray)
                                Text(event.categoryName ?? "Event")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            
                            Text(event.locationString)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                        .padding(.bottom, 30)
                    }
                    .frame(width: 350)
                }
            }
        }
    }
    
    @ViewBuilder
    private func timeColumnView(for event: MyEvent) -> some View {
        Group {
            if let date = event.parseDate(from: event.startDateTime) {
                timeView(for: date)
            } else {
                Text(event.startTime)
                    .font(.system(size: 18, weight: .semibold))
            }
        }
    }
    
    private func timeView(for date: Date) -> some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "h"
        let hour = formatter.string(from: date)
        
        formatter.dateFormat = "mm"
        let minute = formatter.string(from: date)
        
        formatter.dateFormat = "a"
        let amPm = formatter.string(from: date)
        
        return VStack {
            Text(hour)
                .font(.system(size: 18, weight: .semibold))
            Text("\(minute)\n\(amPm)")
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
        }
    }
}

