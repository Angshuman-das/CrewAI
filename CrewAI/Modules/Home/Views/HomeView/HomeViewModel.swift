//
//  HomeViewModel.swift
//  CrewAI
//
//  Created by Angshuman on 03/01/26.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    
    init() {}
}
