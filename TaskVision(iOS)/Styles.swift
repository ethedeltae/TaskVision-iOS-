//
//  Styles.swift
//  CoursesApp(deltae)
//
//  Created by Abhilekh Borah on 16/07/23.
//

import SwiftUI

struct StrokeModifier: ViewModifier{
    var cornerRadius: CGFloat
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content.overlay(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).stroke(.linearGradient(colors: [.white.opacity(colorScheme == .dark ? 0.6 : 0.3), .black.opacity(colorScheme == .dark ? 0.3 : 0.1)], startPoint: .top, endPoint: .bottom))
            .blendMode(.overlay)
        )
    }
}

extension View{
    func strokeStyle(cornerRadius: CGFloat) -> some View{
        modifier(StrokeModifier(cornerRadius: cornerRadius))
    }
}
