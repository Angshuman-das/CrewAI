//
//  ChatListItemView.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import SwiftUI

struct ChatListItemView: View {
    let chat: Chat
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            AvatarView(avatarName: "sparkles")
            DataContentView(chatData: chat)
        }
    }
}

extension ChatListItemView {
    @ViewBuilder
    private func DataContentView(chatData: Chat) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            HStack {
                Text(chatData.title)
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColors.primaryText(for: colorScheme))
                    .lineLimit(1)
                
                Spacer()
                
                Text(chatData.lastMessageTimestamp.toDate.smartFormat())
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText(for: colorScheme))
                
            }
            
            if !chatData.lastMessage.isEmpty {
                Text(chatData.lastMessage)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(AppColors.secondaryText(for: colorScheme))
                    .lineLimit(2)
            }
        }
    }
    
    @ViewBuilder
    private func AvatarView(avatarName: String) -> some View {
        ZStack {
            Circle()
                .fill(AppColors.primaryForeground(for: colorScheme))
                .frame(width: 52, height: 52)
            
            Image(systemName: avatarName)
                .font(AppTypography.title3)
                .foregroundStyle(AppColors.background(for: colorScheme))
        }
    }
}

#Preview {
    let chat = Chat(
        id: UUID().uuidString,
        title: "New Chat",
        lastMessage: "Please book me a ticket",
        lastMessageTimestamp: .nan,
        createdAt: .nan,
        updatedAt: .nan
    )
    
    ChatListItemView(chat: chat)
        .padding(.horizontal)
}
