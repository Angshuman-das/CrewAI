//
//  EmptyStateView.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import SwiftUI

public struct EmptyStateView: View {
  let icon: String
  let title: String
  let subtitle: String
  let actionTitle: String?
  let action: (() -> Void)?
   
  @Environment(\.colorScheme) var colorScheme
   
  public init(
    icon: String,
    title: String,
    subtitle: String,
    actionTitle: String? = nil,
    action: (() -> Void)? = nil
  ) {
    self.icon = icon
    self.title = title
    self.subtitle = subtitle
    self.actionTitle = actionTitle
    self.action = action
  }
   
  public var body: some View {
    VStack(spacing: AppSpacing.lg) {
      ZStack {
        Circle()
          .fill(AppColors.primaryForeground(for: colorScheme))
          .frame(width: 100, height: 100)
          .opacity(0.15)
         
        Image(systemName: icon)
          .font(.system(size: 48, weight: .medium))
          .foregroundColor(AppColors.primary)
      }
       
      VStack(spacing: AppSpacing.sm) {
        Text(title)
          .font(AppTypography.title3)
          .foregroundColor(AppColors.primaryText(for: colorScheme))
         
        Text(subtitle)
          .font(AppTypography.body)
          .foregroundColor(AppColors.secondaryText(for: colorScheme))
          .multilineTextAlignment(.center)
          .padding(.horizontal, AppSpacing.lg)
      }
       
      if let actionTitle = actionTitle, let action = action {
        Button(action: action) {
          Text(actionTitle)
            .font(AppTypography.headline)
            .foregroundColor(.white)
            .padding(.horizontal, AppSpacing.xl)
            .padding(.vertical, AppSpacing.md)
            .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.full))
        }
        .glassEffect(.regular.tint(.red).interactive())
        .padding(.top, AppSpacing.md)
      }
    }
    .padding(AppSpacing.xl)
  }
}


#Preview {
    @Previewable @StateObject var theme: AppTheme = AppTheme.shared
    EmptyStateView(
        icon: "bubble.left.and.bubble.right",
        title: "No conversation",
        subtitle: "Start a new chat to begin your conversation with AI",
        actionTitle: "New Chat") {
            //
        }
        .environmentObject(theme)
        .preferredColorScheme(theme.isDarkMode ? .dark : .light)
}
