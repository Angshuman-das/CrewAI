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
            HomeView(viewModel: coordinator.homeViewModel)
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .chatDetails(let chatId):
                        EmptyView() // T.B.D
                    }
                }
        }
        .environmentObject(theme)
        .preferredColorScheme(theme.isDarkMode ? .dark : .light)
    }
}

public class AppCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    let homeViewModel: HomeViewModel
    
    public init() {
        let homeDataManager = HomeDataManager()
        self.homeViewModel = HomeViewModel(dataManager: homeDataManager)
        
        setupNavigationCallbacks()
    }
    
    private func setupNavigationCallbacks() {
        homeViewModel.onChatSelected = { [weak self] chatId in
            self?.navigateToChatDetails(chatId: chatId)
        }
        
        homeViewModel.onNewChatCreated = { [weak self] chatId in
            self?.navigateToChatDetails(chatId: chatId)
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
