//
//  GratefulMomentsApp.swift
//  GratefulMoments
//
//  Created by ALEX WLADIMIR SALCEDO SILVA on 11/3/26.
//

import SwiftUI
import SwiftData

@main
struct GratefulMomentsApp: App {
    let dataContainer = DataContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataContainer)
        }
        .modelContainer(dataContainer.modelContainer)
    }
}
