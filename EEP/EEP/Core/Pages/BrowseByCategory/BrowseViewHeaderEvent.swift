//
//  BrowseViewHeaderEvent.swift
//  EEP
//
//  Created by m1 pro on 25.12.25.
//



import SwiftUI

struct BrowseViewHeaderEvent: View {
    @State var searchEvent: String = ""
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
                    TextField("🔎︎ Search Events..", text: $searchEvent)
                        .padding()
                        .frame(width: 250,height: 45)
                        .border(.gray, width: 1)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(5)
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Image("filter")
                                .resizable()
                                .frame(width: 20,height: 20)
                            Text("Filters")
                                .foregroundStyle(Color.black)
                        }.background(
                            Rectangle()
                                .fill(.white)
                                .frame(width: 100,height: 45)
                                .border(Color.gray, width: 1)
                                .cornerRadius(5)
                        )
                    })
                }
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 400,height: 2)
            }
        
    }
}

#Preview {
    Browse()
}
