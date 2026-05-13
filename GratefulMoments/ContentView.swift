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
        VStack {
            Button("Create a Grateful Moment") {
                isPresented = true
            }
            .buttonStyle(.bordered)
            .sheet(isPresented: $isPresented) {
                MomentEntryView()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
