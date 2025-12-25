//
//  BrowseViewHeaderEvent.swift
//  EEP
//
//  Created by m1 pro on 25.12.25.
//



import SwiftUI

struct BrowseViewHeaderEvent: View {
    @Binding var searchText: String
    var body: some View {
       
            VStack {
                HStack {
                    Text("Browse Events")
                        .font(.title)
                    Spacer()
                    Image("CalendarIcon")
                        .resizable()
                        .frame(width: 25,height: 30)
                }.padding(.horizontal)
                HStack(spacing: 30) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 12)
                        TextField("Search Events..", text: $searchText)
                    }
                    .padding(.vertical, 12)
                    .frame(width: 250, height: 45)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    
                    Button(action: {
                    }, label: {
                        HStack(spacing: 6) {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .foregroundColor(.black)
                                .font(.system(size: 18))
                            Text("Filters")
                                .foregroundStyle(Color.black)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .frame(width: 100, height: 45)
                        .background(.white)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    })
                }
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 400,height: 2)
            }
        
    }
}
