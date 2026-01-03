//
//  HomeDataManager.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import Foundation

protocol HomeDataManagerProtocol {
    func fetchChats() -> [Chat]
    func createNewChat() -> Chat
    func deleteChat(id: String)
}

class HomeDataManager: HomeDataManagerProtocol {
    private let databaseManager: DatabaseManagerProtocol
    
    init(databaseManager: DatabaseManagerProtocol = DatabaseManager.shared) {
        self.databaseManager = databaseManager
    }
    
    func fetchChats() -> [Chat] {
        return databaseManager.fetchAllChats()
    }
    
    func createNewChat() -> Chat {
        return databaseManager.createChat()
    }
    
    func deleteChat(id: String) {
        databaseManager.deleteChat(id: id)
    }
}
