//
//  SelectRadiusView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 30.05.2022.
//

import SwiftUI

struct SelectRadiusView: View {
    @Binding var radius: Int
    @GestureState private var widthOffset: CGFloat = 0
    private let maximumRadius: CGFloat = 20_000

    var body: some View {
        GeometryReader { proxy in
            VStack {
                ZStack(alignment: .bottomLeading) {
                    ZStack {
                        RadiusIndicatorView(
                            startAngle: .degrees(30),
                            endAngle: .degrees(150),
                            clockwise: true
                        )
                        .fill(Color.marineBlue)
                        .frame(width: 36, height: 66)

                        Text(String(format: "%.1f", (CGFloat(radius) + widthOffset) / 1_000))
                            .foregroundColor(.white)
                    }
                    .offset(x: (CGFloat(radius) + widthOffset) / maximumRadius * (proxy.size.width - 30), y: 0)
                    .animation(.easeInOut, value: widthOffset)
                    .gesture(
                        DragGesture()
                            .updating($widthOffset) { value, state, _ in
                                state = value.translation.width * 3
                            }
                            .onEnded { value in
                                radius += Int(value.translation.width) * 3
                            }
                    )

                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .frame(width: (CGFloat(radius) + widthOffset) / maximumRadius * (proxy.size.width - 30), height: 12)
                            .offset(x: 0, y: 6)
                            .foregroundColor(.marineBlue)

                        RoundedRectangle(cornerRadius: 6)
                            .frame(height: 12)
                            .offset(x: 0, y: 6)
                            .foregroundColor(.gray.opacity(0.2))
                    }
                    .padding(.horizontal, 15)
                }

                HStack {
                    Text("0")
                    Spacer()
                    Text("\(Int(maximumRadius / 1_000)) km")
                }
                .foregroundColor(.gray)
                .padding(.horizontal)
            }
        }
        .frame(height: 44)
    }
}

struct SelectRadiusView_Previews: PreviewProvider {
    static var previews: some View {
        SelectRadiusView(radius: .constant(10000))
            .padding(44)
    }
}
