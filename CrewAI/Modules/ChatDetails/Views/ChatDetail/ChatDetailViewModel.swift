//
//  ChatDetailViewModel.swift
//  CrewAI
//
//  Created by Angshuman on 04/01/26.
//

import Foundation
import SwiftUI
import PhotosUI
import Combine
import AVFoundation
import Photos

/// Error types for chat details
enum ChatDetailsError: Identifiable {
    case cameraPermissionDenied
    case photoLibraryPermissionDenied
    case imageSaveFailed
    case cameraNotAvailable
    
    var id: String {
        switch self {
        case .cameraPermissionDenied: return "cameraPermissionDenied"
        case .photoLibraryPermissionDenied: return "photoLibraryPermissionDenied"
        case .imageSaveFailed: return "imageSaveFailed"
        case .cameraNotAvailable: return "cameraNotAvailable"
        }
    }
    
    var title: String {
        switch self {
        case .cameraPermissionDenied: return "Camera Access Denied"
        case .photoLibraryPermissionDenied: return "Photo Library Access Denied"
        case .imageSaveFailed: return "Save Failed"
        case .cameraNotAvailable: return "Camera Not Available"
        }
    }
    
    var message: String {
        switch self {
        case .cameraPermissionDenied:
            return "Please enable camera access in Settings to take photos."
        case .photoLibraryPermissionDenied:
            return "Please enable photo library access in Settings to select photos."
        case .imageSaveFailed:
            return "Failed to save the image. Please try again."
        case .cameraNotAvailable:
            return "Camera is not available on this device."
        }
    }
}

/// ViewModel for chat details screen
class ChatDetailsViewModel: ObservableObject {
    @Published var chat: Chat?
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    @Published var showImagePicker: Bool = false
    @Published var selectedImage: UIImage?
    @Published var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var fullscreenImage: UIImage?
    @Published var isEditingTitle: Bool = false
    @Published var editableTitleText: String = ""
    @Published var isAgentThinking: Bool = false
    @Published var errorAlert: ChatDetailsError?
    
    private let chatId: String
    private let dataManager: ChatDetailsDataManagerProtocol
    private var userMessagesSinceLastAIResponse: Int = 0
    private var cancellables = Set<AnyCancellable>()
    private var aiResponseTimer: Timer?
    private let debounceDelay: TimeInterval = 2.5
    
    var onBack: (() -> Void)?
    
    init(chatId: String, dataManager: ChatDetailsDataManagerProtocol = ChatDetailsDataManager()) {
        self.chatId = chatId
        self.dataManager = dataManager
        loadChatData()
        
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.loadMessages()
            }
            .store(in: &cancellables)
    }
    
    func loadChatData() {
        chat = dataManager.fetchChat(id: chatId)
        loadMessages()
    }
    
    func loadMessages() {
        messages = dataManager.fetchMessages(for: chatId)
        
        // Calculate user messages since last AI response
        userMessagesSinceLastAIResponse = 0
        for message in messages.reversed() {
            if message.sender == .agent {
                break
            }
            if message.sender == .user {
                userMessagesSinceLastAIResponse += 1
            }
        }
    }
    
    func sendMessage() {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty || selectedImage != nil else { return }
        
        dataManager.sendMessage(text: trimmedText, chatId: chatId, image: selectedImage)
        
        inputText = ""
        selectedImage = nil
        
        loadMessages()
        
        // Cancel existing timer to reset debounce
        aiResponseTimer?.invalidate()
        
        // Start new timer that triggers AI response after user inactivity
        aiResponseTimer = Timer.scheduledTimer(withTimeInterval: debounceDelay, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            self.dataManager.generateAIResponse(
                for: self.chatId,
                userMessagesSinceLastAIResponse: self.userMessagesSinceLastAIResponse,
                onThinkingStart: { [weak self] in
                    DispatchQueue.main.async {
                        self?.isAgentThinking = true
                    }
                },
                onThinkingEnd: { [weak self] in
                    DispatchQueue.main.async {
                        self?.isAgentThinking = false
                        self?.loadMessages()
                    }
                }
            )
        }
    }
    
    func showImagePickerWithSource(_ sourceType: UIImagePickerController.SourceType) {
        if sourceType == .camera {
            // Check camera availability
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                errorAlert = .cameraNotAvailable
                return
            }
            
            // Check camera permission
            let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraStatus {
            case .authorized:
                imagePickerSourceType = sourceType
                showImagePicker = true
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                    DispatchQueue.main.async {
                        if granted {
                            self?.imagePickerSourceType = sourceType
                            self?.showImagePicker = true
                        } else {
                            self?.errorAlert = .cameraPermissionDenied
                        }
                    }
                }
            case .denied, .restricted:
                errorAlert = .cameraPermissionDenied
            @unknown default:
                errorAlert = .cameraPermissionDenied
            }
        } else {
            // Check photo library permission
            let photoStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            switch photoStatus {
            case .authorized, .limited:
                imagePickerSourceType = sourceType
                showImagePicker = true
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                    DispatchQueue.main.async {
                        if status == .authorized || status == .limited {
                            self?.imagePickerSourceType = sourceType
                            self?.showImagePicker = true
                        } else {
                            self?.errorAlert = .photoLibraryPermissionDenied
                        }
                    }
                }
            case .denied, .restricted:
                errorAlert = .photoLibraryPermissionDenied
            @unknown default:
                errorAlert = .photoLibraryPermissionDenied
            }
        }
    }
    
    func imageSelected(_ image: UIImage) {
        selectedImage = image
    }
    
    func showFullscreenImage(_ image: UIImage) {
        fullscreenImage = image
    }
    
    func dismissFullscreenImage() {
        fullscreenImage = nil
    }
    
    func navigateBack() {
        onBack?()
    }
    
    func startEditingTitle() {
        editableTitleText = chat?.title ?? ""
        isEditingTitle = true
    }
    
    func saveTitle() {
        let trimmedTitle = editableTitleText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            isEditingTitle = false
            return
        }
        
        dataManager.updateChatTitle(trimmedTitle, for: chatId)
        loadChatData()
        isEditingTitle = false
    }
    
    func cancelTitleEditing() {
        isEditingTitle = false
        editableTitleText = ""
    }
    
    var canSendMessage: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedImage != nil
    }
}
