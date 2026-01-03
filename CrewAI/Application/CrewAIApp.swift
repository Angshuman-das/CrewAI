//
//  CrewAIApp.swift
//  CrewAI
//
//  Created by Angshuman on 02/01/26.
//

import SwiftUI

@main
struct CrewAIApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ThemedAppView(coordinator: coordinator)
        }
    }
}
