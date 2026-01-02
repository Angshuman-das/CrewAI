//
//  AppTheme.swift
//  CrewAI
//
//  Created by Angshuman on 02/01/26.
//

import SwiftUI
import Combine

public class AppTheme: ObservableObject {
    @Published public var isDarkMode: Bool = false
    
    public static let shared = AppTheme()
    
    private init() {
        isDarkMode = UITraitCollection.current.userInterfaceStyle == .dark
    }
    
    public func toggleTheme() {
        isDarkMode.toggle()
    }
}

public struct AppColors {
    
    public static func background(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .black : .white
    }
    
    public static func primaryText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .white : .black
    }
    
    public static func secondaryText(for colorScheme: ColorScheme) -> Color {
        .secondary
    }
}

// MARK: - Typography
public struct AppTypography {
    public static let largeTitle = Font.system(size: 34, weight: .bold)
    public static let title = Font.system(size: 28, weight: .bold)
    public static let title2 = Font.system(size: 22, weight: .bold)
    public static let title3 = Font.system(size: 20, weight: .semibold)
    public static let headline = Font.system(size: 17, weight: .semibold)
    public static let body = Font.system(size: 17, weight: .regular)
    public static let callout = Font.system(size: 16, weight: .regular)
    public static let subheadline = Font.system(size: 15, weight: .regular)
    public static let footnote = Font.system(size: 13, weight: .regular)
    public static let caption = Font.system(size: 12, weight: .regular)
    public static let caption2 = Font.system(size: 11, weight: .regular)
}

// MARK: - Spacing
public struct AppSpacing {
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 16
    public static let lg: CGFloat = 24
    public static let xl: CGFloat = 32
    public static let xxl: CGFloat = 48
}

// MARK: - Radius
public struct AppCornerRadius {
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 18
    public static let xl: CGFloat = 24
    public static let full: CGFloat = 999
}
