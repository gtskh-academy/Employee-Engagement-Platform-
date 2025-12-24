//
//  Browse.swift
//  EEP
//
//  Created by m1 pro on 25.12.25.
//


import SwiftUI


struct Browse: View {
    let categories = EventCategory.allCases
    let events = Event.array
    let itemHeight: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 20) {
            BrowseViewHeaderEvent()
                .padding(.bottom, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    Button(action: {
                        
                    }, label: {
                        Text("All")
                            .foregroundStyle(.white)
                            .frame(width: 50,height: 40)
                            .background(Color.black)
                            .cornerRadius(20)
                    })
                    ForEach(categories) { category in
                        Button(action: {
                            
                        }, label: {
                            Text(category.rawValue)
                                .font(.footnote)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 12)
                                .frame(height: itemHeight)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(20)
                        })
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: itemHeight + 10)
            ScrollView {
                ForEach(events) { event in
                    ZStack {
                        Rectangle()
                            .fill(.gray.opacity(0.1))
                            .frame(width: 380, height: 170)
                            .cornerRadius(8)
                            .padding(.bottom, 10)
                        HStack(alignment: .top, spacing: 20) {
                            VStack(spacing: 4) {
                                Text(event.month)
                                    .font(.title2)
                                    .foregroundStyle(.black.opacity(0.5))
                                Text("\(event.day)")
                                    .font(.title)
                            }
                            .frame(width: 60)
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 10) {
                                    Text(event.eventByCategory.rawValue)
                                        .font(.system(size: 12))
                                        .foregroundStyle(.black.opacity(0.9))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(20)
                                        .lineLimit(1)
                                    Spacer()
                                    Text(event.status.rawValue)
                                        .font(.system(size: 12))
                                        .foregroundStyle(.black.opacity(0.9))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color.gray.opacity(0.5))
                                        .cornerRadius(20)
                                        .lineLimit(1)
                                }
                                Text(event.title)
                                    .font(.title3)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text("⏱ AM \(event.startTime) - \(event.endTime) PM")
                                    .font(.footnote)
                                    .lineLimit(1)
                                HStack(spacing: 4) {
                                    Image("map")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    Text(event.location)
                                        .font(.footnote)
                                        .lineLimit(1)
                                }
                                
                                // Registered Count
                                HStack(spacing: 4) {
                                    Image("people")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    Text("\(event.registeredCount.description) registered")
                                        .font(.footnote)
                                        .lineLimit(1)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .frame(width: 380, height: 170, alignment: .topLeading)
                    }
                }
            }.scrollIndicators(.hidden)
        }
    }
}


#Preview {
    Browse()
}
