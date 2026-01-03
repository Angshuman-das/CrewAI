//
//  ChatDetailView.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import SwiftUI

struct ChatDetailView: View {
    @Binding var text: String
    @EnvironmentObject private var theme: AppTheme
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 0) {
//            Toggle("isOn", isOn: $theme.isDarkMode)
            
            Spacer()
            
            MessageInputView(text: $text, canSend: false, onSend: {})
        }
    }
}

extension ChatDetailView {}

#Preview {
    @Previewable @State var text: String = ""
    @Previewable @StateObject var theme: AppTheme = AppTheme.shared
    ChatDetailView(text: $text)
        .environmentObject(theme)
        .preferredColorScheme(theme.isDarkMode ? .dark : .light)
}
