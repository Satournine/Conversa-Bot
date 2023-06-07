//
//  ContentView.swift
//  ConversaBot
//
//  Created by user226229 on 4.06.2023.
//

import SwiftUI
import Combine
struct ChatView: View {
    @ObservedObject var viewModel = ViewModel()
    let appName = "ConversaBot" // Replace with your app's name
    @State private var scrollToBottom = false
    @State private var showErrorAlert = false
    @State private var showAlert = false
    
    private var errorAlert: Alert{
        Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
    }
    
    var body: some View {
        VStack {
            Text(appName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple)

            ScrollView {
                ScrollViewReader { scrollView in
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.messages.filter({ $0.role != .system }), id: \.id) { message in
                            MessageView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        scrollToBottom = true
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        scrollToBottom = true
                    }
                    .onReceive(Just(scrollToBottom)) { _ in
                        withAnimation {
                            scrollView.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                        }
                        scrollToBottom = false
                    }
                }
            }
            if viewModel.isTyping{
                ProgressView("Typing...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 50)
            }

            HStack {
                Button(action: {
                            viewModel.clearMessages()
                }) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.red)
                                .clipShape(Circle())
                        }
                        .padding(.leading)
                TextField("Enter a message", text: $viewModel.currentInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                

                Button(action: {
                    viewModel.sendMessage()
                    scrollToBottom = true
                }) {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.purple)
                        .cornerRadius(8)
                }
                .padding(.trailing)
            }
            .padding(.bottom)
            
           
        }
        .alert(isPresented: $showAlert) {
            errorAlert
        }
    }

}


    
func formatTimestamp(_ timestamp: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: timestamp)
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
