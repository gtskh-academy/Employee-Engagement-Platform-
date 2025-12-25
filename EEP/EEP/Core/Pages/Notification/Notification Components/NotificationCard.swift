//
//  NotificationCard.swift
//  EEP
//
//  Created by m1 pro on 25.12.25.
//


import SwiftUI

struct NotificationCard: View {
    
    let notification: AppNotification
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            Image(systemName: notification.icon)
                .frame(width: 36, height: 36)
                .background(Color.gray.opacity(0.15))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text("\(notification.title): \(notification.message)")
                    .font(.subheadline)
                
                Text(notification.time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if notification.isUnread {
                Circle()
                    .fill(Color.black)
                    .frame(width: 8, height: 8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2))
        )
    }
}
