//
//  EventDetailView.swift
//  EEP
//
//  Created by m1 pro on 24.12.25.
//


import SwiftUI

struct EventDetailView: View {
    let event: Event
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            Text("Event Banner Image")
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        HStack(spacing: 8) {
                            TagView(text: "Workshop",background: .gray.opacity(0.2))
                            
                            TagView(text: "Beginner", background: .black)
                        }
                        .padding(.top, 16)
                        
                        Text(event.title)
                            .font(.title2)
                            .bold()
                        
                        HStack(spacing: 12) {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                            Text("\(event.month) \(event.day), 2025")
                                .font(.subheadline)
                        }
                        
                        HStack(spacing: 12) {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                            Text("\(event.startTime) - \(event.endTime)")
                                .font(.subheadline)
                        }
                        
                        HStack(spacing: 12) {
                            Image(systemName: "mappin.circle")
                                .foregroundColor(.gray)
                            Text(event.location)
                                .font(.subheadline)
                        }
                        
                        HStack(spacing: 12) {
                            Image(systemName: "person.2")
                                .foregroundColor(.gray)
                            Text("\(event.registeredCount) registered, 7 spots left")
                                .font(.subheadline)
                        }
                        
                        CommonButton(title: "Register Now") {
                        }
                        .padding(.top, 8)
                        
                        Text("Registration closes on Dec 19, 2025 at 5:00 PM.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        Text("About this event")
                            .font(.headline)
                        
                        Text(event.description)
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.7))
                            .lineSpacing(4)
                            .padding(.top, 4)
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        Text("Agenda")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(alignment: .top, spacing: 12) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 32, height: 32)
                                        Text("1")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }
                                    
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 2, height: 40)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("02:00 PM - Welcome & Introduction")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text("Overview of the workshop goals and key topics.")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineSpacing(3)
                                }
                                
                                Spacer()
                            }
                            
                            HStack(alignment: .top, spacing: 12) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 32, height: 32)
                                        Text("2")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }
                                    
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 2, height: 40)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("02:15 PM - The Art of Active Listening")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text("Interactive exercises on understanding and responding.")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineSpacing(3)
                                }
                                
                                Spacer()
                            }
                            
                            HStack(alignment: .top, spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 32, height: 32)
                                    Text("3")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("03:30 PM - Q&A and Closing Remarks")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text("Open forum and summary of key takeaways.")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineSpacing(3)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.top, 8)
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        Text("Featured Speakers")
                            .font(.headline)
                        
                        VStack(spacing: 16) {
                            SpeakerView(
                                name: "Sarah Johnson",
                                title: "VP of Human Resources"
                            )
                            
                            SpeakerView(
                                name: "David Chen",
                                title: "Lead Corporate Trainer"
                            )
                        }
                        .padding(.top, 8)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("Event Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    EventDetailView(event: Event.array[0])
}
