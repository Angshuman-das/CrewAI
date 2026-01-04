//
//  MessageBubbleView.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    let onImageTap: (UIImage) -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .bottom, spacing: AppSpacing.sm) {
            if message.sender == .user {
                Spacer()
            }
            
            VStack(alignment: message.sender == .user ? .trailing : .leading, spacing: AppSpacing.xs) {
               
                if message.type == .file, let file = message.file {
                    fileMessageContent(file: file)
                } else {
                    TextMessageContent
                }
                
                Text(message.timestamp.toDate.chatTimeFormat())
                    .font(AppTypography.caption2)
                    .foregroundColor(AppColors.secondaryText(for: colorScheme))
            }
            
            if message.sender == .agent {
                Spacer()
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.xs)
    }
}

extension MessageBubbleView {
    private var TextMessageContent: some View {
        Text(message.message)
            .font(AppTypography.body)
            .foregroundColor(message.sender == .user ? .white : AppColors.primaryText(for: colorScheme))
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm + 2)
            .background(
                Group {
                    if message.sender == .user {
                        RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                            .fill(AppColors.userBubble(for: colorScheme))
                            .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
                    } else {
                        RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                            .fill(AppColors.agentBubble(for: colorScheme))
                    }
                }
            )
    }
    
    @ViewBuilder
    private func fileMessageContent(file: MessageFile) -> some View {
        VStack(alignment: message.sender == .user ? .trailing : .leading, spacing: AppSpacing.sm) {
            
            if let image = FileManagerHelper.loadImage(from: file.path) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 250, maxHeight: 250)
                    .clipShape(RoundedRectangle(cornerRadius: AppCornerRadius.md))
                    .onTapGesture {
                        onImageTap(image)
                    }
            } else {
                // Placeholder when image fails to load
                ZStack {
                    RoundedRectangle(cornerRadius: AppCornerRadius.md)
                        .fill(AppColors.surfaceSecondary(for: colorScheme))
                        .frame(width: 250, height: 200)
                    
                    VStack(spacing: AppSpacing.sm) {
                        Image(systemName: "photo")
                            .font(.system(size: 48))
                            .foregroundColor(AppColors.secondaryText(for: colorScheme))
                        
                        Text("Image unavailable")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.secondaryText(for: colorScheme))
                    }
                }
            }
            
            Text(FileManagerHelper.formatFileSize(file.fileSize))
                .font(AppTypography.caption)
                .foregroundColor(AppColors.secondaryText(for: colorScheme))
            
            if !message.message.isEmpty {
                Text(message.message)
                    .font(AppTypography.body)
                    .foregroundColor(message.sender == .user ? .white : AppColors.primaryText(for: colorScheme))
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm + 2)
                    .background(
                        Group {
                            if message.sender == .user {
                                RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                                    .fill(AppColors.userBubble(for: colorScheme))
                                    .shadow(color: Color.blue.opacity(0.3), radius: 4, x: 0, y: 2)
                            } else {
                                RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                                    .fill(AppColors.agentBubble(for: colorScheme))
                            }
                        }
                    )
            }
        }
    }
}

#Preview {
    @Previewable var message: Message = Message(id: UUID.generateString(), chatId: UUID.generateString(), message: "Please help me", sender: .user, timestamp: Date.timeIntervalSinceReferenceDate)
    MessageBubbleView(message: message, onImageTap: {_ in })
}
