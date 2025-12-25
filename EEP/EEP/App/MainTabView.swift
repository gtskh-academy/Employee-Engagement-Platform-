//
//  MainTabView.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//
import SwiftUI

struct MainTabView: View {
    @ObservedObject private var tabSelectionManager = TabSelectionManager.shared
    
    var body: some View {
        TabView(selection: $tabSelectionManager.selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            BrowseByCategory()
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
            
            NotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(4)
        }
        .environmentObject(tabSelectionManager)
    }
}

#Preview {
    MainTabView()
}

