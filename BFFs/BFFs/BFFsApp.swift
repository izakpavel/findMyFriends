//
//  BFFsApp.swift
//  BFFs
//
//  Created by Pavel Zak on 19.05.2021.
//

import SwiftUI

@main
struct BFFsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
            //ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)//PersistenceController.preview.container.viewContext
        }
    }
}
