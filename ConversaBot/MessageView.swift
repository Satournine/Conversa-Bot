//
//  MessageView.swift
//  ConversaBot
//
//  Created by user226229 on 7.06.2023.
//

import SwiftUI

struct MessageView: View{
    let message: Message
    
    var body: some View{
            HStack {
                if message.role == .user {
                    Spacer()
                }

                VStack(alignment: message.role == .user ? .trailing : .leading) {
                    Text(message.content)
                        .padding()
                        .background(message.role == .user ? Color.purple : Color.gray.opacity(0.3))
                        .cornerRadius(8)

                    if message.role == .assistant {
                        Text(formatTimestamp(message.createAt)) // Replace with the timestamp of the message
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                }
                .alignmentGuide(.trailing, computeValue: { _ in
                    message.role == .user ? UIScreen.main.bounds.width : 0
                })
                .alignmentGuide(.leading, computeValue: { _ in
                    message.role == .assistant ? UIScreen.main.bounds.width : 0
                })

                if message.role == .assistant {
                    Spacer()
                }
            }
        }
}
