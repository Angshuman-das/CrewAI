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
    @State private var chatToDelete: Chat?
    @State private var showDeleteAlert = false
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            AppColors.background(for: colorScheme)
                .ignoresSafeArea()
            
            ContentView()
        }
        .navigationTitle("Chats")
        .navigationBarTitleDisplayMode(.large)
        .toolbar(content: {
            ToolbarItemToggleButton()
        })
        .alert("Delete Chat", isPresented: $showDeleteAlert, presenting: chatToDelete) { chat in
            Button("Delete", role: .destructive) {
                viewModel.deleteChat(chat)
                chatToDelete = nil
            }
            Button("Cancel", role: .cancel) {
                chatToDelete = nil
            }
        } message: { chat in
            Text("Are you sure you want to delete \"\(chat.title)\"? This action cannot be undone.")
        }
        .onAppear {
            viewModel.loadChats()
        }
    }
}

extension HomeView {
    private func ChatList() -> some View {
        List {
            ForEach(viewModel.chats) { chat in
                ChatListItemView(chat: chat)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectChat(chat)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            chatToDelete = chat
                            showDeleteAlert = true
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
            viewModel.createNewChat()
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
                    viewModel.createNewChat()
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
    
    private func ToolbarItemToggleButton() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: AppSpacing.md) {
                Button(action: {
                    theme.toggleTheme()
                }) {
                    Image(systemName: theme.isDarkMode ? "sun.max.fill" : "moon.fill")
                        .font(.system(size: 20))
                            .foregroundColor(AppColors.primaryText(for: colorScheme))
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
