//
//  MyEventsHeaderView.swift
//  EEP
//
//  Created by m1 pro on 24.12.25.
//

import SwiftUI

struct MyEventsHeaderView: View {
    @Binding var selectedMode: EventsViewMode
    
    var body: some View {
        VStack {
            Text("My Events")
                .font(.title)
           
            Picker("View Mode", selection: $selectedMode) {
               ForEach(EventsViewMode.allCases) { mode in
                    Text(mode.rawValue)
                    .tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 10)
            Rectangle()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 400, height: 2)
        }
    }
}

