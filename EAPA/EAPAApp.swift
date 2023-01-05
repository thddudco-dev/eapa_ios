//
//  EAPAApp.swift
//  EAPA
//
//  Created by 송영채 on 2023/01/05.
//

import SwiftUI

@main
struct EAPAApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
