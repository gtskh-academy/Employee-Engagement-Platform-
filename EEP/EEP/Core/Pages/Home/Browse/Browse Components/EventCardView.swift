//
//  EventCardView.swift
//  EEP
//
//  Created by m1 pro on 24.12.25.
//

import SwiftUI

struct EventCardView: View {
    
    let event: EventModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 160)
                .overlay(Text("Event Image"))
            
            HStack {
                Text(event.title)
                    .font(.headline)
                
                Spacer()
                
                statusBadge
            }
            
            Text(event.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            infoRow(icon: "calendar", text: event.dateText)
            infoRow(icon: "clock", text: event.time)
            infoRow(icon: "location", text: event.location)
            
            buttonSection
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 3)
    }
    
    private var buttonSection: some View {
        Group {
            if event.status == .registered {
                CommonButton(title: "View Details") {}
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.black)
                    )
            } else {
                CommonButton(
                    title: event.status == .full ? "Join Waitlist" : "View Details",
                    action: {}
                )
            }
        }
    }
    
    private var statusBadge: some View {
        Text(
            event.status == .registered
            ? "Registered"
            : event.status == .full
            ? "Full"
            : "\(event.spotsLeft ?? 0) spots left"
        )
        .font(.caption)
        .padding(6)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
    
    private func infoRow(icon: String, text: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            Text(text)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
