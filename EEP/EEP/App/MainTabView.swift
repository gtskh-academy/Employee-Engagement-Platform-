//
//  MainTabView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            BrowseView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Browse")
                }
                .tag(1)
            
            MyEventsView()
                .tabItem {
                    Image(systemName: "ticket.fill")
                    Text("My Events")
                }
                .tag(2)
            
            UpdatesView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Updates")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(4)
        }
    }
}

#Preview {
    MainTabView()
}

