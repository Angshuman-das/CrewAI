//
//  UUID+Extension.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import Foundation

public extension UUID {
    static func generateString() -> String {
        UUID().uuidString
    }
}
