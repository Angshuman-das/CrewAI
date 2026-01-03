//
//  HomeView.swift
//  CrewAI
//
//  Created by Angshuman on 02/01/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @EnvironmentObject private var theme: AppTheme
    @Environment(\.colorScheme) var colorScheme
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            AppColors.background(for: colorScheme)
                .ignoresSafeArea()
            
            ContentView()
                
            Toggle("isDark", isOn: $theme.isDarkMode)
        }
    }
}

extension HomeView {
    private func ChatList() -> some View {
        List {
            ForEach(viewModel.chats) { chat in
                ChatListItemView(chat: chat)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            //
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private func NewChatButton() -> some View {
        Button {
            //
        } label: {
            Label("New Chat", systemImage: "square.and.pencil")
                .font(AppTypography.headline)
                .labelStyle(.titleAndIcon)
                .frame(width: 160, height: 60)
                .foregroundColor(AppColors.primaryText(for: colorScheme))
        }
        .glassEffect(.regular.tint(.red).interactive())
        .padding(32)
    }
    
    @ViewBuilder
    private func ContentView() -> some View {
        if viewModel.chats.isEmpty {
            EmptyStateView(
                icon: "bubble.left.and.bubble.right",
                title: "No conversation",
                subtitle: "Start a new chat to begin your conversation with AI",
                actionTitle: "New Chat") {
                    //
                }
        } else {
            ChatList()
            
            VStack(spacing: 0) {
                Spacer()
                
                HStack {
                    Spacer()
                    NewChatButton()
                }
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var theme: AppTheme = AppTheme.shared
    let viewModel = HomeViewModel()
    HomeView(viewModel: viewModel)
        .environmentObject(theme)
        .preferredColorScheme(theme.isDarkMode ? .dark : .light)
}
