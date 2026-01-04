//
//  AppCoordinator.swift
//  CrewAI
//
//  Created by Angshuman on 04/01/26.
//

import SwiftUI
import Combine

enum NavigationDestination: Hashable {
    case chatDetails(chatId: String)
}

struct ThemedAppView: View {
    @StateObject var coordinator: AppCoordinator
    @StateObject var theme = AppTheme.shared
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            coordinator.homeCoordinator.start()
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .chatDetails(let chatId):
                        coordinator.chatDetailsCoordinator.start(chatId: chatId)
                    }
                }
        }
        .environmentObject(theme)
        .preferredColorScheme(theme.isDarkMode ? .dark : .light)
    }
}

public class AppCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    let homeCoordinator: HomeCoordinator
    let chatDetailsCoordinator: ChatDetailsCoordinator
    
    public init() {
        self.homeCoordinator = HomeCoordinator()
        self.chatDetailsCoordinator = ChatDetailsCoordinator()
        
        setupCoordinatorCallbacks()
    }
    
    private func setupCoordinatorCallbacks() {
        homeCoordinator.setOnChatSelected { [weak self] chatId in
            self?.navigateToChatDetails(chatId: chatId)
        }
        
        chatDetailsCoordinator.setOnBack { [weak self] in
            self?.navigateBack()
        }
    }
    
    func navigateToChatDetails(chatId: String) {
        navigationPath.append(NavigationDestination.chatDetails(chatId: chatId))
    }
    
    func navigateBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
}
