//
//  ArrowBackButton.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct ArrowBackButton: ViewModifier {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let color: Color?

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        Image("back_arrow")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(color ?? .black)
                            .frame(width: 12, height: 24)
                    }
                }
            }
    }
}

extension View {
    func arrowBackButtonStyle(color: Color? = nil) -> some View {
        modifier(ArrowBackButton(color: color))
    }
}
