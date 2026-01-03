//
//  HomeViewModel.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    
    private let dataManager: HomeDataManagerProtocol
    var onChatSelected: ((String) -> Void)?
    var onNewChatCreated: ((String) -> Void)?
    
    init(dataManager: HomeDataManagerProtocol = HomeDataManager()) {
        self.dataManager = dataManager
        loadChats()
    }
    
    func loadChats() {
        chats = dataManager.fetchChats()
    }
    
    func createNewChat() {
        let newChat = dataManager.createNewChat()
        loadChats()
        onNewChatCreated?(newChat.id)
    }
    
    func selectChat(_ chat: Chat) {
        onChatSelected?(chat.id)
    }
    
    func deleteChat(_ chat: Chat) {
        dataManager.deleteChat(id: chat.id)
        loadChats()
    }
}
