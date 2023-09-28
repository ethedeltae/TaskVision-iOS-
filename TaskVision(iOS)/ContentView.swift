//
//  ContentView.swift
//  TaskVision(iOS)
//
//  Created by Abhilekh Borah on 27/09/23.
//

import SwiftUI
import RealityKit
import ARKit
import UIKit


struct ContentView : View {
    @State var isPlacementEnabled: Bool = false
    @State var selectedModel: String?
    @State var modelConfirmedForPlacement: String?
    @State var isPlacingObject: Bool = false
    @State var isTextWritten: Bool = false
    @State var isDisplayed: Bool = false
    @State var textInfo: String = ""
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer(isPlacingObject: $isPlacingObject, modelConfirmedForPlacement: $modelConfirmedForPlacement, isTextWritten: $isTextWritten, textInfoAR: $textInfo).edgesIgnoringSafeArea(.all)
            
            
          
            if isPlacementEnabled == true {
                cancelAndConfirm
            }
            else {
                if isDisplayed == false {
                    VStack{
                        Text("Choose a model to place")
                            .font(.caption).fontWeight(.bold).foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        modelsView
                        
                        Button {
                            isTextWritten.toggle()
                        } label: {
                            Text("Write a text")
                                .font(.headline)
                                .foregroundStyle(LinearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .padding()
                                .frame(height: 50)
                                .background(.ultraThinMaterial)
                                .cornerRadius(16)
                        }
                        .padding()
                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        Link("Learn about AR", destination: URL(string: "https://fantastic-belekoy-057137.netlify.app/")!)

                        ForEach(0..<10){_ in
                            Spacer()
                        }
                        
                        
                        
                    }
                    .background(.ultraThinMaterial, in:
                                    RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .edgesIgnoringSafeArea(.all)
                }
                else{
                    Button {
                        isDisplayed.toggle()
                    } label: {
                        Text("Place a new model")
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
        .sheet(isPresented: $isTextWritten, content: {
            ChooseTaskView(textInfo: $textInfo, isTextWritten: $isTextWritten, isDisplayed: $isDisplayed)
           
        })
    }
    
    var cancelAndConfirm: some View {
        HStack(spacing: 30) {
            
            // Cancel Button
            
            Button {
                isPlacementEnabledToggle()
                selectedModel = nil
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 50, height: 50)
                    .font(.caption)
                    .background(.ultraThinMaterial)
                    .mask(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .strokeStyle(cornerRadius: 16)
            }
            
            // Confirm Button
            
            Button {
                isPlacementEnabledToggle()
                modelConfirmedForPlacement = selectedModel
                isPlacingObject = true
                isDisplayed = true
                print("\(textInfo)")
                
            } label: {
                Image(systemName: "checkmark")
                    .frame(width: 50, height: 50)
                    .font(.caption)
                    .background(.ultraThinMaterial)
                    .mask(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .strokeStyle(cornerRadius: 16)
            }

            
        }
        .padding()
    }

    
    var modelsView: some View {
        VStack{
            TabView {
                ForEach(Array(modelItem.enumerated()), id: \.offset) { index, item in
                    GeometryReader { proxy in
                        let minX = proxy.frame(in: .global).minX
                        ModelView(model: item)
                            .frame(maxWidth: 500)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 40)
                            .rotation3DEffect(.degrees(minX / -10), axis: (x: 0, y: 0, z: 1))
                            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                            .blur(radius: abs(minX) / 40)
                    }
                    .onTapGesture {
                        isPlacementEnabledToggle()
                        selectedModel = item.imageName
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            Spacer()
        }
    }
    
    func isPlacementEnabledToggle() {
        withAnimation(.easeInOut(duration: 0.2)){
            isPlacementEnabled.toggle()
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var isPlacingObject: Bool
    @Binding var modelConfirmedForPlacement: String?
    @Binding var isTextWritten: Bool
    @Binding var textInfoAR: String
 
    func makeUIView(context: Context) -> ARView {
            let arView = ARView(frame: .zero)
            arView.session.delegate = context.coordinator
            return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if !isTextWritten{
            if isPlacingObject {
                Task {
                    do {
                        // Loading the .usdz file asynchronously
                        if let modelURL = Bundle.main.url(forResource: modelConfirmedForPlacement, withExtension: "usdz") {
                            let anchor = AnchorEntity(.plane(.any, classification: .any, minimumBounds: [0.5, 0.5]))
                            let modelEntity = try await Entity.load(contentsOf: modelURL)
                            anchor.addChild(modelEntity)
                            uiView.scene.addAnchor(anchor)
                        }
                        isPlacingObject = false
                    } catch {
                        print("Error loading model: \(error.localizedDescription)")
                    }
                }
            }
        }
        else{
            var lastText = findLongestConcatenatedWord([textInfoAR])
            let textAnchor = AnchorEntity()
            textAnchor.addChild(textGen(textString: "greetings, judges!"))
            print(lastText)
            uiView.scene.addAnchor(textAnchor)
        }
    }
    
    func textGen(textString: String) -> ModelEntity {
        
        let materialVar = SimpleMaterial(color: .black, roughness: 0, isMetallic: false)
        
        let depthVar: Float = 0.001
        let fontVar = UIFont.systemFont(ofSize: 0.01)
        let containerFrameVar = CGRect(x: -0.05, y: -0.1, width: 0.1, height: 0.1)
        let alignmentVar: CTTextAlignment = .center
        let lineBreakModeVar : CTLineBreakMode = .byWordWrapping
        
        let textMeshResource : MeshResource = .generateText(textString,
                                                            extrusionDepth: depthVar,
                                                            font: fontVar,
                                                            containerFrame: containerFrameVar,
                                                            alignment: alignmentVar,
                                                            lineBreakMode: lineBreakModeVar)
        
        let textEntity = ModelEntity(mesh: textMeshResource, materials: [materialVar])
        
        return textEntity
    }

    func findLongestConcatenatedWord(_ words: [String]) -> String {
        var wordSet = Set(words)
        var longest = ""
        
        func canFormWord(_ word: String) -> Bool {
            if word.isEmpty { return false }
            if word == longest { return true }
            
            for index in word.indices.dropLast() {
                let prefix = String(word[..<index])
                let suffix = String(word[index...])
                
                if wordSet.contains(prefix) && canFormWord(suffix) {
                    return true
                }
            }
            
            return false
        }
        
        for word in words {
            if canFormWord(word) {
                if word.count > longest.count || (word.count == longest.count && word < longest) {
                    longest = word
                }
            }
        }
        
        return longest
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
            super.init()
        }
    }
}
#Preview {
    ContentView()
}
