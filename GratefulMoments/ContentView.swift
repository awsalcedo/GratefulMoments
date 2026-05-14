//
//  ContentView.swift
//  GratefulMoments
//
//  Created by ALEX WLADIMIR SALCEDO SILVA on 11/3/26.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresented = false
    
    var body: some View {
        TabView {
            Tab("Moments", image: "MomentsTab") {
                MomentsView()
            }
            
            Tab("Achievements", systemImage: "medal.fill") {
                AchievementsView()
            }
        }
    }
}

#Preview {
    ContentView()
        .sampleDataContainer()
}
