//
//  BrowseEventCardView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import SwiftUI

struct BrowseEventCardView: View {
    let event: BrowseEvent
    
    var body: some View {
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
                        if let categoryName = event.categoryName {
                            Text(categoryName)
                                .font(.system(size: 12))
                                .foregroundStyle(.black.opacity(0.9))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(20)
                                .lineLimit(1)
                        }
                        Spacer()
                        Text(event.statusString)
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
                    
                    Text("⏱ \(event.startTime) - \(event.endTime)")
                        .font(.footnote)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Image("map")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(event.locationString)
                            .font(.footnote)
                            .lineLimit(1)
                    }
                    
                    HStack(spacing: 4) {
                        Image("people")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text("\(event.confirmedCount ?? 0) registered")
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
}

