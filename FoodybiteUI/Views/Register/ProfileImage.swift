//
//  ProfileImage.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import PhotosUI

struct ProfileImage: View {
    let backgroundColor: Color
    @State private var selectedItem: PhotosPickerItem?
    @Binding var selectedImageData: Data?

    var body: some View {
        PhotosPicker(selection: $selectedItem,
                     matching: .images,
                     photoLibrary: .shared()) {
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    if let selectedImageData,
                       let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(backgroundColor.opacity(0.25))

                        Image(systemName: "person")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                }

                Image(systemName: "arrow.up")
                    .padding()
                    .overlay(Circle().stroke(.white, lineWidth: 3))
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.marineBlue))
                    .font(.system(size: 30, weight: .bold))
            }
            .frame(width: 180, height: 180)
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage(backgroundColor: .black,
                     selectedImageData: .constant(nil))
    }
}
