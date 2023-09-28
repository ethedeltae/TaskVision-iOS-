//
//  ModelView.swift
//  ARApp-wAR2
//
//  Created by Abhilekh Borah on 30/08/23.
//

import SwiftUI

struct ModelView: View {
    var model: ModelData = modelItem[0]
    var body: some View {
        VStack(spacing: 5){
            Image(model.imageName).resizable().aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 90)
                .mask(Circle())
                .padding()

            Text(model.title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(LinearGradient(colors: [.primary, .primary.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding(.bottom, 10)
        }
        .background(.gray.opacity(0.5))
        .mask(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .strokeStyle(cornerRadius: 16)
        .padding()
    }
}

struct ModelView_Preview: PreviewProvider {
    static var previews: some View {
        ModelView()
    }
}
