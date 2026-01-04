//
//  ChatViewModifiers.swift
//  CrewAI
//
//  Created by Angshuman on 04/01/26.
//

import SwiftUI
import UIKit

// MARK: - Navigation Bar Modifier
public struct NavigationBarModifier<ToolbarTitle: View>: ViewModifier {
    let toolbarTitle: ToolbarTitle
    
    public func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    toolbarTitle
                }
            }
    }
}

// MARK: - Attachment Dialog Modifier
public struct AttachmentDialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    let onPhotoLibrary: () -> Void
    let onCamera: () -> Void
    
    public func body(content: Content) -> some View {
        content
            .confirmationDialog("Choose Image Source", isPresented: $isPresented) {
                Button("Photo Library") {
                    onPhotoLibrary()
                }
                Button("Camera") {
                    onCamera()
                }
                Button("Cancel", role: .cancel) {}
            }
    }
}

// MARK: - Image Picker Sheet Modifier
public struct ImagePickerSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    let sourceType: UIImagePickerController.SourceType
    let onImageSelected: (UIImage) -> Void
    
    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                ImagePickerView(
                    isPresented: $isPresented,
                    sourceType: sourceType,
                    onImageSelected: onImageSelected
                )
            }
    }
}

// MARK: - Full Screen Image Modifier
public struct FullScreenImageModifier: ViewModifier {
    @Binding var image: FullscreenImageWrapper?
    let onDismiss: () -> Void
    
    public func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $image) { wrapper in
                FullscreenImageView(image: wrapper.image, onDismiss: onDismiss)
            }
    }
}

// MARK: - Error Alert Modifier
public struct ErrorAlertModifier: ViewModifier {
    @Binding var error: ChatDetailsError?
    
    public func body(content: Content) -> some View {
        content
            .alert(item: $error) { error in
                Alert(
                    title: Text(error.title),
                    message: Text(error.message),
                    primaryButton: .default(Text("Settings"), action: {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
    }
}

// MARK: - Supporting Types
public struct FullscreenImageWrapper: Identifiable {
    public let id = UUID()
    public let image: UIImage
    
    public init(image: UIImage) {
        self.image = image
    }
}
