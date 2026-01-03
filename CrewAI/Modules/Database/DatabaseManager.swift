//
//  DatabaseManager.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import Foundation
import SwiftData

public protocol DatabaseManagerProtocol {
    func fetchAllChats() -> [Chat]
    func fetchChat(id: String) -> Chat?
    func createChat() -> Chat
    func updateChat(_ chat: Chat)
    func deleteChat(id: String)
    
    func fetchMessages(for chatId: String) -> [Message]
    func createMessage(_ message: Message)
    func deleteMessage(id: String)
}

public class DatabaseManager: DatabaseManagerProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    public static let shared = DatabaseManager()
    
    private init() {
        do {
            let schema = Schema([
                ChatEntity.self,
                MessageEntity.self
            ])
            
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            self.modelContext = ModelContext(modelContainer)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    // MARK: - Chat Operations
    
    public func fetchAllChats() -> [Chat] {
        let descriptor = FetchDescriptor<ChatEntity>(
            sortBy: [SortDescriptor(\.lastMessageTimestamp, order: .reverse)]
        )
        
        do {
            let entities = try modelContext.fetch(descriptor)
            return entities.map { Chat(from: $0) }
        } catch {
            print("Error fetching chats: \(error)")
            return []
        }
    }
    
    public func fetchChat(id: String) -> Chat? {
        let chatId = id
        let predicate = #Predicate<ChatEntity> { $0.id == chatId }
        let descriptor = FetchDescriptor<ChatEntity>(predicate: predicate)
        
        do {
            let entities = try modelContext.fetch(descriptor)
            return entities.first.map { Chat(from: $0) }
        } catch {
            print("Error fetching chat: \(error)")
            return nil
        }
    }
    
    public func createChat() -> Chat {
        let entity = ChatEntity()
        modelContext.insert(entity)
        save()
        return Chat(from: entity)
    }
    
    public func updateChat(_ chat: Chat) {
        let chatId = chat.id
        let predicate = #Predicate<ChatEntity> { $0.id == chatId }
        let descriptor = FetchDescriptor<ChatEntity>(predicate: predicate)
        
        do {
            let entities = try modelContext.fetch(descriptor)
            if let entity = entities.first {
                entity.title = chat.title
                entity.lastMessage = chat.lastMessage
                entity.lastMessageTimestamp = chat.lastMessageTimestamp
                entity.updatedAt = chat.updatedAt
                save()
            }
        } catch {
            print("Error updating chat: \(error)")
        }
    }
    
    public func deleteChat(id: String) {
        let chatId = id
        let predicate = #Predicate<ChatEntity> { $0.id == chatId }
        let descriptor = FetchDescriptor<ChatEntity>(predicate: predicate)
        
        do {
            let entities = try modelContext.fetch(descriptor)
            if let entity = entities.first {
                modelContext.delete(entity)
                save()
            }
        } catch {
            print("Error deleting chat: \(error)")
        }
    }
    
    // MARK: - Message Operations
    
    public func fetchMessages(for chatId: String) -> [Message] {
        let chatIdentifier = chatId
        let predicate = #Predicate<MessageEntity> { $0.chatId == chatIdentifier }
        let descriptor = FetchDescriptor<MessageEntity>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )
        
        do {
            let entities = try modelContext.fetch(descriptor)
            return entities.map { Message(from: $0) }
        } catch {
            print("Error fetching messages: \(error)")
            return []
        }
    }
    
    public func createMessage(_ message: Message) {
        let entity = MessageEntity(
            id: message.id,
            chatId: message.chatId,
            message: message.message,
            type: message.type.rawValue,
            filePath: message.file?.path,
            fileSize: message.file?.fileSize,
            thumbnailPath: message.file?.thumbnail?.path,
            sender: message.sender.rawValue,
            timestamp: message.timestamp
        )
        
        modelContext.insert(entity)
        
        updateChatLastMessage(chatId: message.chatId, lastMessage: message.message, timestamp: message.timestamp)
        
        save()
    }
    
    public func deleteMessage(id: String) {
        let messageId = id
        let predicate = #Predicate<MessageEntity> { $0.id == messageId }
        let descriptor = FetchDescriptor<MessageEntity>(predicate: predicate)
        
        do {
            let entities = try modelContext.fetch(descriptor)
            if let entity = entities.first {
                modelContext.delete(entity)
                save()
            }
        } catch {
            print("Error deleting message: \(error)")
        }
    }
    
    // MARK: - Private Helpers
    
    private func updateChatLastMessage(chatId: String, lastMessage: String, timestamp: TimeInterval) {
        let chatIdentifier = chatId
        let predicate = #Predicate<ChatEntity> { $0.id == chatIdentifier }
        let descriptor = FetchDescriptor<ChatEntity>(predicate: predicate)
        
        do {
            let entities = try modelContext.fetch(descriptor)
            if let entity = entities.first {
                entity.lastMessage = lastMessage
                entity.lastMessageTimestamp = timestamp
                entity.updatedAt = Date().toTimestamp
            }
        } catch {
            print("Error updating chat last message: \(error)")
        }
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
