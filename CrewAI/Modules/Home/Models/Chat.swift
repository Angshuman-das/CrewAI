//
//  Chat.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import Foundation

public struct Chat: Identifiable, Equatable {
    public let id: String
    public var title: String
    public var lastMessage: String
    public var lastMessageTimestamp: TimeInterval
    public let createdAt: TimeInterval
    public var updatedAt: TimeInterval
    
    
    public init(
        id: String,
        title: String,
        lastMessage: String,
        lastMessageTimestamp: TimeInterval,
        createdAt: TimeInterval,
        updatedAt: TimeInterval
    ) {
        self.id = id
        self.title = title
        self.lastMessage = lastMessage
        self.lastMessageTimestamp = lastMessageTimestamp
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
