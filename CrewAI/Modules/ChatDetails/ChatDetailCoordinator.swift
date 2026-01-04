//
//  ChatDetailCoordinator.swift
//  CrewAI
//
//  Created by Angshuman on 04/01/26.
//

import SwiftUI

public class ChatDetailsCoordinator {
    private var onBack: (() -> Void)?
    
    public init() {}
    
    public func setOnBack(_ action: @escaping () -> Void) {
        self.onBack = action
    }
    
    public func start(chatId: String) -> some View {
        let dataManager = ChatDetailsDataManager()
        let viewModel = ChatDetailsViewModel(chatId: chatId, dataManager: dataManager)
        
        viewModel.onBack = { [weak self] in
            self?.onBack?()
        }
        
        return ChatDetailView(viewModel: viewModel)
    }
}
