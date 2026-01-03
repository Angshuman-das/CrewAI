//
//  ChatEntity.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import Foundation
import SwiftData

@Model
final class ChatEntity {
    @Attribute(.unique) var id: String
    var title: String
    var lastMessage: String
    var lastMessageTimestamp: TimeInterval
    var createdAt: TimeInterval
    var updatedAt: TimeInterval
    
    @Relationship(deleteRule: .cascade, inverse: \MessageEntity.chat)
    var messages: [MessageEntity]?
    
    init(
        id: String = UUID.generateString(),
        title: String = "New Chat",
        lastMessage: String = "",
        lastMessageTimestamp: TimeInterval = Date().toTimestamp,
        createdAt: TimeInterval = Date().toTimestamp,
        updatedAt: TimeInterval = Date().toTimestamp
    ) {
        self.id = id
        self.title = title
        self.lastMessage = lastMessage
        self.lastMessageTimestamp = lastMessageTimestamp
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
