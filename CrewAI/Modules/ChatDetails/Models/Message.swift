//
//  Message.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import Foundation

public enum MessageType: String, Codable {
    case text
    case file
}

public enum MessageSender: String, Codable {
    case user
    case agent
}

public struct MessageFile: Codable, Equatable {
    public let path: String
    public let fileSize: Int64
    public let thumbnail: MessageThumbnail?
    
    public init(path: String, fileSize: Int64, thumbnail: MessageThumbnail? = nil) {
        self.path = path
        self.fileSize = fileSize
        self.thumbnail = thumbnail
    }
}

public struct MessageThumbnail: Codable, Equatable {
    public let path: String
    
    public init(path: String) {
        self.path = path
    }
}

public struct Message: Identifiable, Equatable {
    public let id: String
    public let chatId: String
    public let message: String
    public let type: MessageType
    public let file: MessageFile?
    public let sender: MessageSender
    public let timestamp: TimeInterval
    
    public init(
        id: String = UUID.generateString(),
        chatId: String,
        message: String,
        type: MessageType = .text,
        file: MessageFile? = nil,
        sender: MessageSender,
        timestamp: TimeInterval
    ) {
        self.id = id
        self.chatId = chatId
        self.message = message
        self.type = type
        self.file = file
        self.sender = sender
        self.timestamp = timestamp
    }
    
    init(from entity: MessageEntity) {
        self.id = entity.id
        self.chatId = entity.chatId
        self.message = entity.message
        self.type = MessageType(rawValue: entity.type) ?? .text
        
        if let filePath = entity.filePath, let fileSize = entity.fileSize {
            let thumbnail = entity.thumbnailPath.map { MessageThumbnail(path: $0) }
            self.file = MessageFile(path: filePath, fileSize: fileSize, thumbnail: thumbnail)
        } else {
            self.file = nil
        }
        
        self.sender = MessageSender(rawValue: entity.sender) ?? .user
        self.timestamp = entity.timestamp
    }
}
