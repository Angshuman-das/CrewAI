//
//  MessageEntity.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//


import Foundation
import SwiftData

@Model
final class MessageEntity {
    @Attribute(.unique) var id: String
    var chatId: String
    var message: String
    var type: String
    var filePath: String?
    var fileSize: Int64?
    var thumbnailPath: String?
    var sender: String
    var timestamp: TimeInterval
    
    var chat: ChatEntity?
    
    init(
        id: String = UUID.generateString(),
        chatId: String,
        message: String,
        type: String = "text",
        filePath: String? = nil,
        fileSize: Int64? = nil,
        thumbnailPath: String? = nil,
        sender: String,
        timestamp: TimeInterval = Date().toTimestamp
    ) {
        self.id = id
        self.chatId = chatId
        self.message = message
        self.type = type
        self.filePath = filePath
        self.fileSize = fileSize
        self.thumbnailPath = thumbnailPath
        self.sender = sender
        self.timestamp = timestamp
    }
}
