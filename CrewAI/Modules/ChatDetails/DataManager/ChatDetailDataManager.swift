//
//  ChatDetailDataManager.swift
//  CrewAI
//
//  Created by Angshuman on 04/01/26.
//

import Foundation
import UIKit

protocol ChatDetailsDataManagerProtocol {
    func fetchChat(id: String) -> Chat?
    func fetchMessages(for chatId: String) -> [Message]
    func sendMessage(text: String, chatId: String, image: UIImage?)
    func generateAIResponse(for chatId: String, userMessagesSinceLastAIResponse: Int, onThinkingStart: @escaping () -> Void, onThinkingEnd: @escaping () -> Void)
    func updateChatTitle(_ title: String, for chatId: String)
}

class ChatDetailsDataManager: ChatDetailsDataManagerProtocol {
    private let databaseManager: DatabaseManagerProtocol
    private let aiService: AIServiceProtocol
    
    init(
        databaseManager: DatabaseManagerProtocol = DatabaseManager.shared,
        aiService: AIServiceProtocol = MockAIService()
    ) {
        self.databaseManager = databaseManager
        self.aiService = aiService
    }
    
    func fetchChat(id: String) -> Chat? {
        return databaseManager.fetchChat(id: id)
    }
    
    func fetchMessages(for chatId: String) -> [Message] {
        return databaseManager.fetchMessages(for: chatId)
    }
    
    func sendMessage(text: String, chatId: String, image: UIImage?) {
        let timestamp = Date().toTimestamp
        
        if let image = image {
            // Save image to documents directory
            if let imagePath = FileManagerHelper.saveImage(image) {
                let fileSize = FileManagerHelper.getFileSize(at: imagePath)
                
                // Create thumbnail
                let thumbnail = FileManagerHelper.createThumbnail(from: image)
                let thumbnailPath = FileManagerHelper.saveImage(thumbnail, filename: "thumb_\(UUID.generateString()).jpg")
                
                let file = MessageFile(
                    path: imagePath,
                    fileSize: fileSize,
                    thumbnail: thumbnailPath.map { MessageThumbnail(path: $0) }
                )
                
                let message = Message(
                    chatId: chatId,
                    message: text,
                    type: .file,
                    file: file,
                    sender: .user,
                    timestamp: timestamp
                )
                
                databaseManager.createMessage(message)
            }
        } else {
            let message = Message(
                chatId: chatId,
                message: text,
                type: .text,
                sender: .user,
                timestamp: timestamp
            )
            
            databaseManager.createMessage(message)
        }
        
        updateChatTitleFromFirstMessage(chatId: chatId, text: text)
    }
    
    /// Generates an AI response
    func generateAIResponse(for chatId: String, userMessagesSinceLastAIResponse: Int, onThinkingStart: @escaping () -> Void, onThinkingEnd: @escaping () -> Void) {
        // AI responds every 4-5 user messages since its last response
        let triggerPoint = Int.random(in: 4...5)
        guard userMessagesSinceLastAIResponse >= triggerPoint else { return }
        
        onThinkingStart()
        
        aiService.generateResponse(for: "") { [weak self] response in
            guard let self = self else {
                onThinkingEnd()
                return
            }
            
            let timestamp = Date().toTimestamp
            
            if let text = response.text {
                // Text response
                let message = Message(
                    chatId: chatId,
                    message: text,
                    type: .text,
                    sender: .agent,
                    timestamp: timestamp
                )
                self.databaseManager.createMessage(message)
                onThinkingEnd()
            } else if let imageURLString = response.imageURL, let imageURL = URL(string: imageURLString) {
                // Download and save image
                self.downloadAndSaveImage(from: imageURL, chatId: chatId, timestamp: timestamp) {
                    onThinkingEnd()
                }
            } else {
                onThinkingEnd()
            }
        }
    }
    
    private func downloadAndSaveImage(from url: URL, chatId: String, timestamp: TimeInterval, completion: @escaping () -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            
            DispatchQueue.main.async {
                // Save image to documents directory
                if let imagePath = FileManagerHelper.saveImage(image) {
                    let fileSize = FileManagerHelper.getFileSize(at: imagePath)
                    
                    // Create thumbnail
                    let thumbnail = FileManagerHelper.createThumbnail(from: image)
                    let thumbnailPath = FileManagerHelper.saveImage(thumbnail, filename: "thumb_\(UUID.generateString()).jpg")
                    
                    let file = MessageFile(
                        path: imagePath,
                        fileSize: fileSize,
                        thumbnail: thumbnailPath.map { MessageThumbnail(path: $0) }
                    )
                    
                    let message = Message(
                        chatId: chatId,
                        message: "Here's an image for you",
                        type: .file,
                        file: file,
                        sender: .agent,
                        timestamp: timestamp
                    )
                    
                    self.databaseManager.createMessage(message)
                }
                
                completion()
            }
        }.resume()
    }
    
    func updateChatTitle(_ title: String, for chatId: String) {
        guard var chat = databaseManager.fetchChat(id: chatId) else { return }
        chat.title = title
        chat.updatedAt = Date().toTimestamp
        databaseManager.updateChat(chat)
    }
    
    private func updateChatTitleFromFirstMessage(chatId: String, text: String) {
        guard var chat = databaseManager.fetchChat(id: chatId),
              chat.title == "New Chat" || chat.title.isEmpty else {
            return
        }
        
        let title = String(text.prefix(40))
        chat.title = title
        chat.updatedAt = Date().toTimestamp
        databaseManager.updateChat(chat)
    }
}
