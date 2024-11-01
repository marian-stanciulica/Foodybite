//
//  RestaurantDetailsView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 01.06.2022.
//

import SwiftUI
import Domain
import FoodybitePresentation

public struct RestaurantDetailsView: View {
    @StateObject var viewModel: RestaurantDetailsViewModel
    let makePhotoView: (String?) -> PhotoView
    let showReviewView: () -> Void

    public init(viewModel: RestaurantDetailsViewModel, makePhotoView: @escaping (String?) -> PhotoView, showReviewView: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.makePhotoView = makePhotoView
        self.showReviewView = showReviewView
    }

    public var body: some View {
        VStack {
            switch viewModel.getRestaurantDetailsState {
            case .idle:
                EmptyView()

            case .isLoading:
                ProgressView()
                Spacer()

            case let .failure(error):
                Text(error.rawValue)
                    .foregroundColor(.red)

                Spacer()

            case let .success(restaurantDetails):
                GeometryReader { proxy in
                    VStack {
                        ScrollView {
                            VStack(alignment: .leading) {
                                RestaurantImageView(
                                    photoView: makePhotoView(restaurantDetails.photos.first?.photoReference),
                                    phoneNumber: restaurantDetails.phoneNumber,
                                    showMaps: showMaps)

                                makeRestaurantInformationView(restaurantDetails)

                                RestaurantPhotosView(
                                    imageWidth: proxy.size.width / 2.5,
                                    photosReferences: restaurantDetails.photos.map { $0.photoReference },
                                    makePhotoView: makePhotoView
                                )
                                .padding(.bottom)

                                makeReviews()
                            }
                        }

                        MarineButton(title: "Rate Your Experience", isLoading: false, action: showReviewView)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .task {
            if viewModel.getRestaurantDetailsState == .idle {
                await viewModel.getRestaurantDetails()
            }

            await viewModel.getRestaurantReviews()
        }
        .arrowBackButtonStyle()
        .navigationTitle("Restaurant Details")
    }

    @ViewBuilder private func makeRestaurantInformationView(_ restaurantDetails: RestaurantDetails) -> some View {
        HStack {
            RestaurantInformationView(
                name: restaurantDetails.name,
                distance: viewModel.distanceInKmFromCurrentLocation,
                address: restaurantDetails.address
            )

            Spacer()

            RatingStar(
                rating: viewModel.rating,
                backgroundColor: .gray.opacity(0.1)
            )
            .padding(4)
        }
        .padding(.horizontal)

        if let openingHoursDetails = restaurantDetails.openingHoursDetails {
            OpenHoursView(openingHoursDetails: openingHoursDetails)
                .padding(.horizontal)
        }
    }

    @ViewBuilder private func makeReviews() -> some View {
        HeaderView(name: "Review & Ratings", allItemsCount: viewModel.reviews.count)

        LazyVStack {
            ForEach(viewModel.reviews) { review in
                ReviewCell(review: review)
            }
        }
    }

    private func showMaps() {
        guard case let .success(restaurantDetails) = viewModel.getRestaurantDetailsState else { return }

        let location = restaurantDetails.location
        guard let url = URL(string: "maps://?saddr=&daddr=\(location.latitude),\(location.longitude)") else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantDetailsView(
                viewModel: RestaurantDetailsViewModel(
                    input: .restaurantIdToFetch("#1"),
                    getDistanceInKmFromCurrentLocation: { _ in 3.4 },
                    restaurantDetailsService: PreviewNearbyRestaurantsService(),
                    getReviewsService: PreviewGetReviewsService()
                ),
                makePhotoView: { _ in
                    PhotoView(
                        viewModel: PhotoViewModel(
                            photoReference: "reference",
                            restaurantPhotoService: PreviewFetchPlacePhotoService()
                        )
                    )
                },
                showReviewView: {}
            )
        }
    }

    private final class PreviewNearbyRestaurantsService: RestaurantDetailsService {
        func getRestaurantDetails(restaurantID: String) async throws -> RestaurantDetails {
            RestaurantDetails(
                id: "place #1",
                phoneNumber: "+61 2 9374 4000",
                name: "Happy Bones",
                address: "48 Pirrama Rd, Pyrmont NSW 2009, Australia",
                rating: 4.5,
                openingHoursDetails: OpeningHoursDetails(
                    openNow: true,
                    weekdayText: [
                        "Monday: 9:00 AM – 5:00 PM",
                        "Tuesday: 9:00 AM – 5:00 PM",
                        "Wednesday: 9:00 AM – 5:00 PM",
                        "Thursday: 9:00 AM – 5:00 PM",
                        "Friday: 9:00 AM – 5:00 PM",
                        "Saturday: Closed",
                        "Sunday: Closed"
                    ]
                ),
                reviews: [
                    Review(
                        restaurantID: "place #1",
                        profileImageURL: URL(string: "www.google.com"),
                        profileImageData: nil,
                        authorName: "Marian",
                        reviewText: "Loren ipsum...",
                        rating: 2,
                        relativeTime: "5 months ago"
                    ),
                    Review(
                        restaurantID: "place #1",
                        profileImageURL: URL(string: "www.google.com"),
                        profileImageData: nil,
                        authorName: "Marian",
                        reviewText: """
                            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut sit amet dapibus justo, eu cursus nulla. Nulla viverra
                            mollis ante et rutrum. Mauris lorem ante, congue eget malesuada quis, hendrerit vel elit. Suspendisse potenti.
                            Phasellus molestie vehicula blandit. Fusce sit amet egestas augue. Integer quis lacinia massa. Aliquam hendrerit arcu
                            eget leo congue maximus. Etiam interdum eget mi at consectetur.
                        """,
                        rating: 4,
                        relativeTime: "1 day ago"
                    )
                ],
                location: Location(latitude: 44.439663, longitude: 26.096306),
                photos: [Photo(width: 100, height: 100, photoReference: "ceva")]
            )
        }
    }

    private final class PreviewFetchPlacePhotoService: RestaurantPhotoService {
        func fetchPhoto(photoReference: String) async throws -> Data {
            UIImage(named: "restaurant_logo_test", in: .current, with: nil)!.pngData()!
        }
    }

    private final class PreviewGetReviewsService: GetReviewsService {
        func getReviews(restaurantID: String?) async throws -> [Review] {
            []
        }
    }
}
