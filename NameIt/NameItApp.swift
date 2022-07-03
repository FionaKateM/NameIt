//
//  NameItApp.swift
//  NameIt
//
//  Created by Fiona Kate Morgan on 03/07/2022.
//

import SwiftUI

@main
struct NameItApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
