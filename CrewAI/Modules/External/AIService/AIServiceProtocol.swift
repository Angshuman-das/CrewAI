//
//  AIServiceProtocol.swift
//  CrewAI
//
//  Created by Angshuman on 04/01/26.
//

import Foundation

public struct AIResponse {
    public let text: String?
    public let imageURL: String?
    
    public init(text: String? = nil, imageURL: String? = nil) {
        self.text = text
        self.imageURL = imageURL
    }
}

public protocol AIServiceProtocol {
    func generateResponse(for message: String, completion: @escaping (AIResponse) -> Void)
}

public class MockAIService: AIServiceProtocol {
    
    public init() {}
    
    private let textResponses = [
        "I'm looking into that for you.",
        "Let me check the details.",
        "Got it! I'll help you with that.",
        "That's a great question. Here's what I found...",
        "I've processed your request.",
        "Interesting! Let me think about that.",
        "Based on what you've told me, here's my analysis.",
        "I understand what you're asking. Here's the answer.",
        "That's a complex topic, but I'll do my best to explain.",
        "Let me break this down for you."
    ]
    
    public func generateResponse(for message: String, completion: @escaping (AIResponse) -> Void) {
        let delay = Double.random(in: 1.0...2.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // 70% chance text, 30% chance image
            let shouldSendText = Double.random(in: 0...1) < 0.7
            
            if shouldSendText {
                let randomResponse = self.textResponses.randomElement() ?? "Hello!"
                completion(AIResponse(text: randomResponse))
            } else {
                // Random placeholder image from Lorem Picsum
                let width = Int.random(in: 300...500)
                let height = Int.random(in: 200...400)
                let imageURL = "https://picsum.photos/\(width)/\(height)"
                completion(AIResponse(imageURL: imageURL))
            }
        }
    }
}
