//
//  ScrollBehaviorModifier.swift
//  CrewAI
//
//  Created by Angshuman on 04/01/26.
//

import SwiftUI

/// ViewModifier to handle scroll behavior for chat messages
public struct ScrollBehaviorModifier: ViewModifier {
    @ObservedObject var viewModel: ChatDetailsViewModel
    let keyboardHeight: CGFloat
    let onKeyboardHeightChanged: (CGFloat) -> Void
    let scrollProxy: ScrollViewProxy
    
    public func body(content: Content) -> some View {
        content
            .onChange(of: viewModel.messages.count) {
                scrollToBottom()
            }
            .onChange(of: viewModel.isAgentThinking) { oldValue, newValue in
                if newValue {
                    scrollToTypingIndicator()
                }
            }
            .onChange(of: keyboardHeight) {
                scrollToBottom(animated: true, duration: 0.25)
            }
            .onAppear {
                setupKeyboardObservers()
                scrollToBottomDelayed(delay: 0.3)
            }
    }
    
    private func scrollToBottom(animated: Bool = true, duration: Double = 0.2) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if animated {
                withAnimation(.easeOut(duration: duration)) {
                    scrollProxy.scrollTo("bottom-spacer", anchor: .bottom)
                }
            } else {
                scrollProxy.scrollTo("bottom-spacer", anchor: .bottom)
            }
        }
    }
    
    private func scrollToTypingIndicator() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                scrollProxy.scrollTo("typing-indicator", anchor: .bottom)
            }
        }
    }
    
    private func scrollToBottomDelayed(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation {
                scrollProxy.scrollTo("bottom-spacer", anchor: .bottom)
            }
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                onKeyboardHeightChanged(keyboardFrame.height)
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            onKeyboardHeightChanged(0)
        }
    }
}
