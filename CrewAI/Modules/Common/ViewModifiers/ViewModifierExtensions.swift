//
//  ViewModifierExtensions.swift
//  CrewAI
//
//  Created by Angshuman on 04/01/26.
//

import SwiftUI

/// Helper extension to apply view modifiers
public extension View {
    func apply<T: ViewModifier>(_ modifier: T) -> some View {
        self.modifier(modifier)
    }
}
