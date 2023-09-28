//
//  ChooseTaskView.swift
//  TaskVision
//
//  Created by Abhilekh Borah on 26/09/23.
//

import SwiftUI

struct ChooseTaskView: View {
    @Binding var textInfo: String
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    @Binding var isTextWritten: Bool
    @Environment(\.colorScheme) var colorScheme
    @Binding var isDisplayed: Bool

    var body: some View {
        VStack{
            Text("AR Text").font(.largeTitle.bold())
                .foregroundColor(colorScheme == .dark ? .white : .black).padding(.top)
            
            TextField("Write a text to display...", text: $textInfo, axis: .vertical)
                .padding()
                .focused($isFocused)
                .lineLimit(4...12)
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        HStack {
                            Spacer()
                            Button("Done") {
                                isFocused = false
                            }
                        }
                    }
                }
                .frame(minHeight: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 16).stroke(LinearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                        .blendMode(.overlay)
                )
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .padding()
            
            Button {
                isTextWritten.toggle()
                isDisplayed.toggle()
                print("\(textInfo)")
                dismiss()
               
            } label: {
                Text("Done")
                    .font(.headline)
                    .foregroundStyle(LinearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .padding()
                    .frame(height: 50)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
            }
            .padding()
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            
        }
        
    }
    
}

#Preview {
    ChooseTaskView(textInfo: .constant(""), isTextWritten: .constant(false), isDisplayed: .constant(false))
}
