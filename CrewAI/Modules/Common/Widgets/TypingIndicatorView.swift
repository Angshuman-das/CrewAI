//
//  TypingIndicatorView.swift
//  CrewAI
//
//  Created by Angshuman on 04/01/26.
//

import SwiftUI

struct TypingIndicatorView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(alignment: .bottom, spacing: AppSpacing.sm) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryForeground(for: colorScheme))
                    .frame(width: 32, height: 32)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.background(for: colorScheme))
            }
            
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                HStack(spacing: 6) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(AppColors.secondaryText(for: colorScheme))
                            .frame(width: 8, height: 8)
                            .offset(y: animationOffset)
                            .animation(
                                Animation
                                    .easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                value: animationOffset
                            )
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                        .fill(AppColors.agentBubble(for: colorScheme))
                )
                
                Text("AI is thinking...")
                    .font(AppTypography.caption2)
                    .foregroundColor(AppColors.secondaryText(for: colorScheme))
                    .padding(.leading, AppSpacing.xs)
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.xs)
        .onAppear {
            animationOffset = -4
        }
    }
}

#Preview("Light Mode") {
    VStack(spacing: 20) {
        TypingIndicatorView()
        TypingIndicatorView()
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    VStack(spacing: 20) {
        TypingIndicatorView()
        TypingIndicatorView()
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
