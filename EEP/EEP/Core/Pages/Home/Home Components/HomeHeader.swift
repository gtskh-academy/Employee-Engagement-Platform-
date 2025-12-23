//
//  HomeHeader.swift
//  team11
//
//  Created by m1 pro on 22.12.25.
//
import SwiftUI

struct HomeHeader: View {
    
    var body: some View {
        HStack {
            Image(systemName: "calendar")
                .resizable()
                .foregroundStyle(Color.white)
                .frame(width: 20, height: 20)
                .padding(8)
                .background(Color.black)
                .cornerRadius(10)
            
            Text("Event Hub")
                .font(.title2)
                .bold()
            
            Spacer()
            
            Image(systemName: "bell.badge.fill")
                .resizable()
                .frame(width: 20, height: 24)
                .foregroundColor(.gray)
            
            Spacer()
                .frame(width: 20)
            
            Image("PersonIcon")
                .resizable()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
        }
        
    }
}
