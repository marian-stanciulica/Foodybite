//
//  PhotoView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import SwiftUI
import Domain

struct PhotoView: View {
    @StateObject var viewModel: PhotoViewModel
    
    var body: some View {
        Group {
            switch viewModel.fetchPhotoState {
            case .isLoading:
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color(uiColor: .systemGray3))
                        .frame(height: 200)
                    
                    ProgressView()
                }
            case .noImageAvailable:
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color(uiColor: .systemGray3))
                        .frame(height: 200)
                    
                    Text("No Image Available")
                        .foregroundColor(.red)
                }
            case .failure:
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color(uiColor: .systemGray3))
                        .frame(height: 200)
                    
                    Image(systemName: "arrow.clockwise.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            Task {
                                await viewModel.fetchPhoto()
                            }
                        }
                }
            case let .success(photoData):
                if let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(1.25, contentMode: .fit)
                }
            }
        }
        .task {
            guard viewModel.fetchPhotoState == .isLoading else { return }
            
            await viewModel.fetchPhoto()
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(viewModel: PhotoViewModel(
            photoReference: "photo reference",
            fetchPhotoService: PreviewFetchPlacePhotoService()
        ))
    }
    
    private class PreviewFetchPlacePhotoService: FetchPlacePhotoService {
        func fetchPlacePhoto(photoReference: String) async throws -> Data {
            throw NSError(domain: "", code: 1)
        }
    }
}
