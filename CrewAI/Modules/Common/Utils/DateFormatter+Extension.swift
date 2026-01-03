//
//  DateFormatter+Extension.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import Foundation

public extension Date {
    
    /// Formats timestamp with smart formatting logic
    /// - Returns: Formatted string like "Just now", "5m ago", "2:30 PM", "Yesterday", "Dec 20"
    func smartFormat() -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(self)
        
        // Less than 1 minute
        if timeInterval < 60 {
            return "Just now"
        }
        
        // Less than 1 hour
        if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes)m ago"
        }
        
        let calendar = Calendar.current
        
        // Today - show time
        if calendar.isDateInToday(self) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: self)
        }
        
        // Yesterday
        if calendar.isDateInYesterday(self) {
            return "Yesterday"
        }
        
        // This year - show month and day
        if calendar.component(.year, from: self) == calendar.component(.year, from: now) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: self)
        }
        
        // Other years - show full date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: self)
    }
    
    /// Formats time for chat messages
    /// - Returns: Time string like "2:30 PM"
    func chatTimeFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
}

public extension TimeInterval {
    var toDate: Date {
        Date(timeIntervalSince1970: self / 1000)
    }
}

public extension Date {
    var toTimestamp: TimeInterval {
        self.timeIntervalSince1970 * 1000
    }
}
