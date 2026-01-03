//
//  HomeCoordinator.swift
//  CrewAI
//
//  Created by Angshuman on 04/01/26.
//

import SwiftUI

public class HomeCoordinator {
    private var onChatSelected: ((String) -> Void)?
    
    public init() {}
    
    public func setOnChatSelected(_ action: @escaping (String) -> Void) {
        self.onChatSelected = action
    }
    
    public func start() -> AnyView {
        let dataManager = HomeDataManager()
        let viewModel = HomeViewModel(dataManager: dataManager)
        
        viewModel.onChatSelected = { [weak self] chatId in
            self?.onChatSelected?(chatId)
        }
        
        viewModel.onNewChatCreated = { [weak self] chatId in
            self?.onChatSelected?(chatId)
        }
        
        return AnyView(HomeView(viewModel: viewModel))
    }
}
