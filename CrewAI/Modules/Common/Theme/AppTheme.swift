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
    
    public static var primary: Color {
        .blue
    }
    
    public static func background(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .black : .white
    }
    
    public static func primaryForeground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .white : .black
    }
    
    public static func surfaceSecondary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark
            ? Color.white.opacity(0.06)
            : Color.black.opacity(0.04)
    }
    
    public static func primaryText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .white : .black
    }
    
    public static func secondaryText(for colorScheme: ColorScheme) -> Color {
        .secondary
    }
    
    public static func userBubble(for colorScheme: ColorScheme) -> LinearGradient {
        colorScheme == .dark
            ? LinearGradient(colors: [Color(hex: "#0A84FF"), Color(hex: "#0051D5")], startPoint: .topLeading, endPoint: .bottomTrailing)
            : LinearGradient(colors: [Color(hex: "#007AFF"), Color(hex: "#0051D5")], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    public static func agentBubble(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "#2C2C2E") : Color(hex: "#F2F2F7")
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

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
