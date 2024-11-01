//
//  RestaurantCell.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import Domain
import SwiftUI
import FoodybitePresentation

public struct RestaurantCell: View {
    let photoView: PhotoView
    @StateObject var viewModel: RestaurantCellViewModel

    public init(photoView: PhotoView, viewModel: RestaurantCellViewModel) {
        self.photoView = photoView
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .top) {
                photoView

                HStack {
                    Text(viewModel.isOpen ? "Open" : "Closed")
                        .fontWeight(.bold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        .foregroundColor(viewModel.isOpen ? .green : .red)
                        .background(Color(uiColor: .systemBackground))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(viewModel.isOpen ? .green : .red, lineWidth: 1)
                        )

                    Spacer()

                    RatingStar(rating: viewModel.rating, backgroundColor: Color(uiColor: .systemGray6))
                }
                .padding()
            }

            RestaurantInformationView(
                name: viewModel.restaurantName,
                distance: viewModel.distance,
                address: nil
            )
            .padding()
        }
        .cornerRadius(16)
    }
}

struct RestaurantCell_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCell(
            photoView: PhotoView(
                viewModel: PhotoViewModel(
                    photoReference: nil,
                    restaurantPhotoService: PreviewFetchPlacePhotoService()
                )
            ),
            viewModel: RestaurantCellViewModel(
                nearbyRestaurant: NearbyRestaurant(
                    id: "place id",
                    name: "Place name",
                    isOpen: true,
                    rating: 3.4,
                    location: Location(latitude: 0, longitude: 0),
                    photo: nil
                ),
                distanceInKmFromCurrentLocation: 3.4
            )
        )
        .cornerRadius(16)
        .padding()
    }

    private final class PreviewFetchPlacePhotoService: RestaurantPhotoService {
        func fetchPhoto(photoReference: String) async throws -> Data {
            return Data()
        }
    }
}
