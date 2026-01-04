//
//  SendButton.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import SwiftUI

public struct SendButton: View {
    let action: () -> Void
    let isDisabled: Bool
    
    public init(isDisabled: Bool = false, action: @escaping () -> Void) {
        self.isDisabled = isDisabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.up.circle.fill")
                .font(AppTypography.title)
                .foregroundColor(isDisabled ? .gray : AppColors.primary)
        }
        .disabled(isDisabled)
    }
}

#Preview("Enabled") {
    SendButton(isDisabled: false) {
        print("Send tapped")
    }
    .padding()
}

#Preview("Disabled") {
    SendButton(isDisabled: true) {
        print("Send tapped")
    }
    .padding()
}
