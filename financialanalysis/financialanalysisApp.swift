//
//  financialanalysisApp.swift
//  financialanalysis
//
//  Created by 堀江奈央 on 2022/08/13.
//

import SwiftUI

@main
struct financialanalysisApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
