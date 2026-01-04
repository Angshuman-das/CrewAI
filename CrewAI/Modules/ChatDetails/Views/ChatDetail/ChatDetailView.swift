//
//  ChatDetailView.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import SwiftUI

struct ChatDetailView: View {
    @StateObject private var viewModel: ChatDetailsViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showAttachmentOptions = false
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var isInputFocused: Bool

    init(viewModel: ChatDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            AppColors.background(for: colorScheme)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                messagesScrollView
                messageInputView
            }
        }
        .apply(navigationBarModifier)
        .apply(attachmentDialogModifier)
        .apply(imagePickerModifier)
        .apply(fullScreenImageModifier)
        .apply(errorAlertModifier)
    }
}

// MARK: - Subviews
extension ChatDetailView {
    
    private var messagesScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: AppSpacing.sm) {
                    messagesList
                    typingIndicator
                    bottomSpacer
                }
                .padding(.vertical, AppSpacing.md)
            }
            .apply(scrollBehaviorModifiers(proxy: proxy))
            .onTapGesture {
                isInputFocused = false
            }
        }
    }
    
    private var messagesList: some View {
        ForEach(viewModel.messages) { message in
            MessageBubbleView(
                message: message,
                onImageTap: { image in
                    viewModel.showFullscreenImage(image)
                }
            )
            .id(message.id)
        }
    }
    
    @ViewBuilder
    private var typingIndicator: some View {
        if viewModel.isAgentThinking {
            TypingIndicatorView()
                .id("typing-indicator")
        }
    }
    
    private var bottomSpacer: some View {
        Color.clear
            .frame(height: 1)
            .id("bottom-spacer")
    }
    
    private var messageInputView: some View {
        MessageInputView(
            text: $viewModel.inputText,
            selectedImage: $viewModel.selectedImage,
            colorScheme: _colorScheme,
            isInputFocused: $isInputFocused,
            canSend: viewModel.canSendMessage
        ) {
            showAttachmentOptions = true
        } onSend: {
            viewModel.sendMessage()
        }
    }
}

// MARK: - Toolbar
extension ChatDetailView {
    
    @ViewBuilder
    private var toolbarTitle: some View {
        if viewModel.isEditingTitle {
            editableTitleView
        } else {
            tappableTitleView
        }
    }
    
    private var editableTitleView: some View {
        HStack(spacing: AppSpacing.sm) {
            TextField("Chat title", text: $viewModel.editableTitleText)
                .font(AppTypography.headline)
                .foregroundColor(AppColors.primaryText(for: colorScheme))
                .textFieldStyle(.plain)
                .submitLabel(.done)
                .onSubmit {
                    viewModel.saveTitle()
                }
            
            Button(action: {
                viewModel.saveTitle()
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.green)
            }
            
            Button(action: {
                viewModel.cancelTitleEditing()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.red)
            }
        }
    }
    
    private var tappableTitleView: some View {
        Button(action: {
            viewModel.startEditingTitle()
        }) {
            HStack(spacing: AppSpacing.xs) {
                Text(viewModel.chat?.title ?? "Chat")
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.primaryText(for: colorScheme))
                    .lineLimit(1)
                
                Image(systemName: "pencil")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(AppColors.secondaryText(for: colorScheme))
            }
        }
    }
}

// MARK: - View Modifiers
extension ChatDetailView {
    
    private var navigationBarModifier: some ViewModifier {
        NavigationBarModifier(toolbarTitle: toolbarTitle)
    }
    
    private var attachmentDialogModifier: some ViewModifier {
        AttachmentDialogModifier(
            isPresented: $showAttachmentOptions,
            onPhotoLibrary: { viewModel.showImagePickerWithSource(.photoLibrary) },
            onCamera: { viewModel.showImagePickerWithSource(.camera) }
        )
    }
    
    private var imagePickerModifier: some ViewModifier {
        ImagePickerSheetModifier(
            isPresented: $viewModel.showImagePicker,
            sourceType: viewModel.imagePickerSourceType,
            onImageSelected: { image in viewModel.imageSelected(image) }
        )
    }
    
    private var fullScreenImageModifier: some ViewModifier {
        FullScreenImageModifier(
            image: Binding(
                get: { viewModel.fullscreenImage.map { FullscreenImageWrapper(image: $0) } },
                set: { viewModel.fullscreenImage = $0?.image }
            ),
            onDismiss: { viewModel.dismissFullscreenImage() }
        )
    }
    
    private var errorAlertModifier: some ViewModifier {
        ErrorAlertModifier(error: $viewModel.errorAlert)
    }
    
    private func scrollBehaviorModifiers(proxy: ScrollViewProxy) -> some ViewModifier {
        ScrollBehaviorModifier(
            viewModel: viewModel,
            keyboardHeight: keyboardHeight,
            onKeyboardHeightChanged: { height in
                keyboardHeight = height
            },
            scrollProxy: proxy
        )
    }
}

// MARK: - Preview
#Preview {
    @Previewable var viewModel = ChatDetailsViewModel(chatId: "")
    @Previewable @State var text: String = ""
    @Previewable @StateObject var theme: AppTheme = AppTheme.shared
    ChatDetailView(viewModel: viewModel)
        .environmentObject(theme)
        .preferredColorScheme(theme.isDarkMode ? .dark : .light)
}
