//
//  MessageInputView.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import SwiftUI

struct MessageInputView: View {
    @Binding var text: String
    @EnvironmentObject private var theme: AppTheme
    @Environment(\.colorScheme) var colorScheme
    let canSend: Bool
    let onSend: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            ImageSelectionButton()
            
            ChatTextFeildView()
            
            SendButton(isDisabled: !canSend, action: onSend)
                .padding(.bottom, AppSpacing.sm)
        }
        .padding(AppSpacing.md)
        .background(AppColors.surfaceSecondary(for: colorScheme))
    }
}

extension MessageInputView {
    private func ImageSelectionButton() -> some View {
        Button(action: {
            //
        }) {
            Image(systemName: "photo")
                .font(AppTypography.title)
                .foregroundColor(AppColors.primaryForeground(for: colorScheme))
        }
        .padding(.bottom, AppSpacing.sm)
    }
    
    private func ChatTextFeildView() -> some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text("Message")
                    .foregroundColor(AppColors.secondaryText(for: colorScheme))
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm + 2)
            }
            
    
            TextEditor(text: $text)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppColors.primaryForeground(for: colorScheme))
                    )
                .font(AppTypography.body)
                .foregroundColor(AppColors.primaryText(for: colorScheme))
                .frame(minHeight: 36, maxHeight: 52)
                .padding(.horizontal, AppSpacing.sm + 2)
                .padding(.vertical, 6)
                .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    @Previewable @StateObject var theme: AppTheme = AppTheme.shared
    MessageInputView(text: $text, canSend: false, onSend: {})
        .environmentObject(theme)
        .preferredColorScheme(theme.isDarkMode ? .dark : .light)
}
