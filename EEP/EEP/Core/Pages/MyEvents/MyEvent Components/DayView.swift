//
//  DayView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import SwiftUI

struct DayView: View {
    let date: Date
    let isSelected: Bool
    let hasEvent: Bool
    let isCurrentMonth: Bool
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                .foregroundColor(isCurrentMonth ? (isSelected ? .white : .black) : .gray)
            
            if hasEvent {
                Circle()
                    .fill(Color.black)
                    .frame(width: 4, height: 4)
            } else {
                Spacer()
                    .frame(height: 4)
            }
        }
        .frame(width: 40, height: 50)
        .background(
            Circle()
                .fill(isSelected ? Color.blue : Color.clear)
                .frame(width: 32, height: 32)
        )
    }
}

