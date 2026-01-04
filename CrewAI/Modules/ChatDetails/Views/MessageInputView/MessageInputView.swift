//
//  MessageInputView.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import SwiftUI

struct MessageInputView: View {
    @Binding var text: String
    @Binding var selectedImage: UIImage?
    @EnvironmentObject private var theme: AppTheme
    @Environment(\.colorScheme) var colorScheme
    @FocusState.Binding var isInputFocused: Bool
    let canSend: Bool
    let onAttachment: () -> Void
    let onSend: () -> Void
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                imagePreview(image)
            }
            
            HStack(alignment: .center) {
                ImageSelectionButton()
                
                ChatTextFeildView()
                
                SendButton(isDisabled: !canSend, action: onSend)
                    .padding(.bottom, AppSpacing.sm)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surfaceSecondary(for: colorScheme))
    }
}

extension MessageInputView {
    private func ImageSelectionButton() -> some View {
        Button(action: {
            onAttachment()
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
                .focused($isInputFocused)
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
    
    private func imagePreview(_ image: UIImage) -> some View {
        HStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.sm))
            
            Spacer()
            
            Button(action: {
                selectedImage = nil
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.surfaceSecondary(for: colorScheme))
    }
}

#Preview {
    @Previewable @State var text: String = ""
    @Previewable @State var selectedImage: UIImage?
    @Previewable @FocusState var isInputFocused: Bool
    @Previewable @StateObject var theme: AppTheme = AppTheme.shared
    MessageInputView(text: $text, selectedImage: $selectedImage, isInputFocused: $isInputFocused, canSend: false, onAttachment: {}, onSend: {})
        .environmentObject(theme)
        .preferredColorScheme(theme.isDarkMode ? .dark : .light)
}
