# CrewAI - AI Chat Application

A modern, modular iOS chat application built with SwiftUI and SwiftData, featuring an AI agent conversation interface with offline-first architecture.

## 🚀 Setup

1. Clone the repository
2. Open `CrewAI.xcodeproj` in Xcode
3. Select your target device/simulator
4. Press `⌘ + R` to build and run

**Requirements:** iOS 17.0+, Xcode 15.0+

---

## 🏗️ Architecture Overview

CrewAI follows a **modular, coordinator-based MVVM architecture** designed for scalability and independent module development. Each module is loosely coupled and can be easily converted into a Swift Package or CocoaPod.

### Project Structure

```
CrewAI/
│
├── Application/                    # 🚀 App Entry Point & Navigation
│   ├── CrewAIApp.swift            # SwiftUI App entry point
│   └── AppCoordinator.swift       # Root coordinator managing all module coordinators
│
└── Modules/                        # 📦 Feature Modules
    │
    ├── Home/                       # 🏠 Chat List Module
    │   ├── HomeCoordinator.swift  # Public: Navigation & module initialization
    │   ├── Models/
    │   │   └── Chat.swift         # Chat model (id, title, lastMessage, timestamps)
    │   ├── Views/
    │   │   ├── HomeView/
    │   │   │   ├── HomeView.swift
    │   │   │   └── HomeViewModel.swift
    │   │   └── ChatListItemView/
    │   │       └── ChatListItemView.swift
    │   └── DataManager/
    │       └── HomeDataManager.swift  # Interacts with Database module
    │
    ├── ChatDetails/                # 💬 Chat Conversation Module
    │   ├── ChatDetailCoordinator.swift  # Public: Navigation & module initialization
    │   ├── Models/
    │   │   └── Message.swift       # Message model (text, file, sender, timestamp)
    │   ├── Views/
    │   │   ├── ChatDetail/
    │   │   │   ├── ChatDetailView.swift
    │   │   │   └── ChatDetailViewModel.swift
    │   │   ├── MessageBubbleView/
    │   │   │   └── MessageBubbleView.swift
    │   │   ├── MessageInputView/
    │   │   │   └── MessageInputView.swift
    │   │   ├── FullScreenImageView/
    │   │   │   └── FullScreenImageView.swift
    │   │   └── ImagePickerView/
    │   │       └── ImagePickerView.swift
    │   └── DataManager/
    │       └── ChatDetailDataManager.swift  # Interacts with Database & AI modules
    │
    ├── Database/                   # 💾 Data Persistence Module
    │   ├── DatabaseManager.swift  # Public: CRUD operations for all modules
    │   └── Models/
    │       ├── ChatEntity.swift   # SwiftData entity for chats
    │       └── MessageEntity.swift # SwiftData entity for messages
    │
    ├── Common/                     # 🎨 Shared Resources Module
    │   ├── Theme/
    │   │   └── AppTheme.swift     # Design system (colors, typography, spacing)
    │   ├── Widgets/
    │   │   ├── EmptyStateView.swift
    │   │   ├── SendButton.swift
    │   │   └── TypingIndicatorView.swift
    │   ├── Utils/
    │   │   ├── DateFormatter+Extension.swift
    │   │   ├── FileManager+Extension.swift
    │   │   └── UUID+Extension.swift
    │   └── ViewModifiers/
    │       ├── ChatViewModifiers.swift
    │       └── ScrollBehaviorModifier.swift
    │
    └── External/                   # 🔌 Third-party Integrations Module
        └── AIService/
            └── AIServiceProtocol.swift  # Public: AI service contract & mock implementation
```

---

## 📦 Module Structure

### **1. Home Module**
The main screen displaying all chat conversations in a list.
- **Components:** HomeCoordinator, HomeView, HomeViewModel, HomeDataManager
- **Responsibilities:** Displays chat list sorted by recent activity, handles new chat creation, manages chat deletion with confirmation, provides empty state UI

### **2. ChatDetails Module**
The core chat interface where users interact with the AI agent.
- **Components:** ChatDetailCoordinator, ChatDetailView, ChatDetailViewModel, ChatDetailDataManager
- **Responsibilities:** Manages message display and input, handles text and image messages, implements AI response simulation with debouncing, provides image picker integration, full-screen image viewing with pinch-to-zoom

### **3. Database Module**
Centralized data persistence layer using SwiftData.
- **Components:** DatabaseManager, ChatEntity, MessageEntity
- **Responsibilities:** Provides offline-first data storage, manages CRUD operations for chats and messages, handles cascade delete relationships

### **4. Common Module**
Shared resources and reusable components across the app.
- **Submodules:**
  - **Theme:** App-wide design system (colors, typography, spacing)
  - **Widgets:** Reusable UI components (EmptyStateView, SendButton, TypingIndicator)
  - **Utils:** Helper utilities (date formatting, file management, UUID generation)

### **5. External Module**
Third-party services and external integrations.
- **Components:** AIServiceProtocol, MockAIService
- **Responsibilities:** Defines AI service contract, provides mock implementation for testing, ready for real AI API integration

---

## 🎯 Why This Architecture?

### **1. Modularity & Separation of Concerns**
Each module has a single responsibility and clear boundaries, making the codebase easy to understand and maintain.

### **2. Independent Development**
Modules can be developed, tested, and versioned independently without affecting other parts of the app.

### **3. Easy Conversion to SPM/CocoaPods**
The architecture is designed to allow any module to be extracted into:
- **Swift Package Manager (SPM)** packages
- **CocoaPods** for distribution
- **Framework** bundles

Simply move a module folder into its own repository with a `Package.swift` or `.podspec` file.

### **4. Coordinator Pattern for Navigation**
- Coordinators handle all navigation logic, keeping views decoupled
- Each module exposes only its coordinator as the public interface
- Other modules interact only through coordinator callbacks
- Makes navigation flows testable and flexible

### **5. Testability**
- ViewModels are easily testable with mock DataManagers
- DataManagers can be tested with mock Database/Services
- Protocol-based design enables dependency injection

### **6. Scalability**
Adding new features or modules follows the same pattern:
1. Create module folder with coordinator
2. Define public protocols
3. Implement internal components
4. Connect via coordinator callbacks

---

## 🔑 Key Features

- ✅ **Offline-First Architecture** - Works without internet connection
- ✅ **AI Chat Simulation** - Debounced responses with typing indicator
- ✅ **Image Handling** - Camera/photo library integration with thumbnails
- ✅ **Full-Screen Image Viewer** - Pinch-to-zoom, pan, and double-tap gestures
- ✅ **Smart Timestamps** - "Just now", "5m ago", "Yesterday" formatting
- ✅ **Editable Chat Titles** - Tap to rename conversations
- ✅ **Dark Mode Support** - Automatic theme switching
- ✅ **Swipe-to-Delete** - With confirmation alert
- ✅ **Empty States** - User-friendly placeholder screens
- ✅ **Keyboard Management** - Dismiss on tap outside

---

## 📱 Screens

### Home Screen
- Chat list with smart timestamps
- New chat floating action button
- Swipe-to-delete with confirmation
- Empty state for new users

### Chat Detail Screen
- Message bubbles (user vs agent styling)
- Text and image message support
- AI typing indicator with animation
- Message input with image picker
- Full-screen image viewer
- Editable chat title

---

## 🛠️ Tech Stack

- **Language:** Swift
- **UI Framework:** SwiftUI
- **Persistence:** SwiftData
- **Architecture:** Coordinator-based MVVM
- **Minimum iOS:** 26.0 (For glass effect) // Can be set minimum target to iOS 18, setting up fallback for glass effect

---

## 📝 License

This project is created as a demonstration of modular iOS architecture.

---

## 👨‍💻 Author

Built with ❤️ for showcasing modern iOS development practices.
