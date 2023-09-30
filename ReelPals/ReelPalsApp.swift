//
//  ReelPalsApp.swift
//  ReelPals
//
//  Created by Roland on 30/9/2023.
//

import SwiftUI

@main
struct ReelPalsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
