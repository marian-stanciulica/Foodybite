//
//  NewReviewView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 31.05.2022.
//

import SwiftUI
import Domain
import FoodybitePresentation

public struct NewReviewView<SelectedView: View>: View {
    @StateObject var viewModel: NewReviewViewModel
    let selectedView: (RestaurantDetails) -> SelectedView
    let dismissScreen: () -> Void

    public init(viewModel: NewReviewViewModel, selectedView: @escaping (RestaurantDetails) -> SelectedView, dismissScreen: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.selectedView = selectedView
        self.dismissScreen = dismissScreen
    }

    public var body: some View {
        ScrollView {
            VStack {
                Text("New Review")
                    .font(.title)

                makeSearchView()

                switch viewModel.getRestaurantDetailsState {
                case .idle:
                    EmptyView()
                case .isLoading:
                    ProgressView()
                        .padding()
                case let .failure(error):
                    Text(error.rawValue)
                        .foregroundColor(.red)
                case let .success(restaurantDetails):
                    selectedView(restaurantDetails)
                }

                makeRatingsView()

                makeRateExperienceTextField()

                Spacer()

                makePostReviewButton()
            }
        }
    }

    @ViewBuilder private func makeSearchView() -> some View {
        NewReviewSearchView(
            searchText: $viewModel.searchText,
            autocompleteResults: $viewModel.autocompleteResults,
            onChange: {
                await viewModel.autocomplete()
            },
            onRestaurantSelected: { restaurantID in
                await viewModel.getRestaurantDetails(restaurantID: restaurantID)
            }
        )
    }

    @ViewBuilder private func makeRatingsView() -> some View {
        Text("Ratings")
            .font(.title)

        RatingView(stars: $viewModel.starsNumber)
            .frame(maxWidth: 300)
    }

    @ViewBuilder private func makeRateExperienceTextField() -> some View {
        Text("Rate your experience")
            .font(.title3)
            .foregroundColor(Color(uiColor: .systemGray))
            .padding()

        Text("Review")
            .font(.title)
            .padding(.top)

        VStack {
            TextField("Write your experience", text: $viewModel.reviewText, axis: .vertical)
                .padding()

            Spacer()
        }
        .frame(height: 150)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
        )
        .padding(.horizontal)
    }

    @ViewBuilder private func makePostReviewButton() -> some View {
        if viewModel.postReviewState == .isLoading {
            ProgressView()
        } else {
            PostReviewButton(
                title: "Post",
                isLoading: viewModel.postReviewState == .isLoading,
                disabled: !viewModel.postReviewEnabled) {
                    Task {
                        await viewModel.postReview()
                    }
                }
            .padding()
        }
    }
}

struct NewReviewView_Previews: PreviewProvider {
    static var previews: some View {
        NewReviewView(
            viewModel: NewReviewViewModel(
                autocompleteRestaurantsService: PreviewAutocompletePlacesService(),
                restaurantDetailsService: PreviewRestaurantDetailsService(),
                addReviewService: PreviewAddReviewService(),
                location: Location(latitude: 0, longitude: 0),
                userPreferences: UserPreferences(radius: 0, starsNumber: 0)
            ),
            selectedView: { restaurantDetails in
                SelectedRestaurantView(
                    photoView: PhotoView(
                        viewModel: PhotoViewModel(
                            photoReference: "reference",
                            restaurantPhotoService: PreviewFetchPlacePhotoService()
                        )
                    ),
                    restaurantDetails: restaurantDetails
                )
            },
            dismissScreen: {}
        )
    }

    private final class PreviewAutocompletePlacesService: AutocompleteRestaurantsService {
        func autocomplete(input: String, location: Location, radius: Int) async throws -> [AutocompletePrediction] {
            let predictions = [
                AutocompletePrediction(restaurantPrediction: "Prediction 1", restaurantID: "place #1"),
                AutocompletePrediction(restaurantPrediction: "Another Pre 2", restaurantID: "place #2")
            ]

            return predictions.filter { $0.restaurantPrediction.contains(input) }
        }
    }

    private final class PreviewRestaurantDetailsService: RestaurantDetailsService {
        func getRestaurantDetails(restaurantID: String) async throws -> RestaurantDetails {
            RestaurantDetails(
                id: "place #1",
                phoneNumber: "",
                name: "Place name",
                address: "Place address",
                rating: 3,
                openingHoursDetails: nil,
                reviews: [],
                location: Location(latitude: 0, longitude: 0),
                photos: [
                    Photo(width: 100, height: 100, photoReference: "")
                ]
            )
        }
    }

    private final class PreviewFetchPlacePhotoService: RestaurantPhotoService {
        func fetchPhoto(photoReference: String) async throws -> Data {
            UIImage(named: "restaurant_logo_test", in: .current, with: nil)!.pngData()!
        }
    }

    private final class PreviewAddReviewService: AddReviewService {
        func addReview(restaurantID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {

        }
    }
}
