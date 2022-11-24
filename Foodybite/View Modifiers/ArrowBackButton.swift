//
//  ArrowBackButton.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI

struct ArrowBackButton: ViewModifier {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

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
                            .frame(width: 12, height: 24)
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

extension View {
    func arrowBackButtonStyle() -> some View {
        modifier(ArrowBackButton())
    }
}
