//
//  EventDetailSheet.swift
//  EEP
//
//  Created by m1 pro on 25.12.25.
//


import SwiftUI

struct EventDetailSheet: View {
    let event: EventDetails
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 12)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(event.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 20)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        Text(event.dateTime)
                            .foregroundColor(.primary)
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.circle")
                            .foregroundColor(.gray)
                        Text(event.location)
                            .foregroundColor(.primary)
                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    VStack(spacing: 16) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.primary)
                                Text("Send a question about the event")
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "calendar.badge.plus")
                                    .foregroundColor(.primary)
                                Text("Add to my calendar")
                                    .foregroundColor(.primary)
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    
                    Spacer(minLength: 20)
                    
                    CommonButton(title: "Cancel Registration") {
                    }
                    .padding(.bottom, 8)
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Close")
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }
}


#Preview {
    EventDetailSheet(event: .dummy)
}
