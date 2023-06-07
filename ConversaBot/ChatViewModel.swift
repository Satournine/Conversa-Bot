//
//  ChatViewModel.swift
//  ConversaBot
//
//  Created by user226229 on 4.06.2023.
//

import Foundation
import SwiftUI

extension ChatView{
    class ViewModel: ObservableObject{
        @Published var messages: [Message] = []
        @Published var currentInput: String = ""
        @Published var isTyping = false
        @Published var errorMessage: String = ""
        @Published var showErrorAlert: Bool = false
        var errorAlert: Alert?
        private let openAIService = OpenAIService()
        func sendMessage(){
            
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            isTyping = true
            
            Task{
                do{
                    let response = await openAIService.sendMessaage(messages: messages)
                    guard let receivedOpenAIMessage = response?.choices.first?.message else{
                        print("No received message")
                        return
                    }
                    let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
                    try await Task.sleep(nanoseconds: 1000000000)
                    await MainActor.run{
                        messages.append(receivedMessage)
                        isTyping = false
                    }
                } catch{
                    DispatchQueue.main.async {
                        self.errorMessage = "Error while connecting to Bot."
                        self.showErrorAlert = true
                        
                    }
                    
                }
                
            }
        }
        func clearMessages() {
                    messages.removeAll()
        }
    }
}

struct Message: Decodable{
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}
