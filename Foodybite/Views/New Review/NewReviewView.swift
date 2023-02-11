//
//  NewReviewView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 31.05.2022.
//

import SwiftUI
import Domain

struct NewReviewView<SelectedView: View>: View {
    @Binding var currentPage: Page
    @Binding var plusButtonActive: Bool
    
    @StateObject var viewModel: NewReviewViewModel
    let selectedView: (PlaceDetails) -> SelectedView
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button("Cancel") {
                        withAnimation {
                            currentPage = .home
                            plusButtonActive = false
                        }
                    }
                    .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("New Review")
                        .font(.title)
                    
                    Spacer()
                    
                    Button("Post") {
                        Task {
                            await viewModel.postReview()
                        }
                    }
                    .foregroundColor(.gray)
                }
                .padding()
                
                SearchView(
                    searchText: $viewModel.searchText,
                    autocompleteResults: $viewModel.autocompleteResults,
                    onChange: {
                        await viewModel.autocomplete()
                    },
                    onPlaceSelected: { placeID in
                        await viewModel.getPlaceDetails(placeID: placeID)
                    }
                )
                
                if case let .requestSucceeeded(placeDetails) = viewModel.getPlaceDetailsState {
                    selectedView(placeDetails)
                }
                
                Text("Ratings")
                    .font(.title)
                
                RatingView(stars: $viewModel.starsNumber)
                    .frame(maxWidth: 300)
                
                Text("Rate your experience")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding()
                
                Text("Review")
                    .font(.title)
                    .padding(.top)
                
                VStack {
                    TextField("Write your experience", text: $viewModel.reviewText)
                        .padding()
                    
                    Spacer()
                }
                .frame(height: 150)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                )
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

struct NewReviewView_Previews: PreviewProvider {
    static var previews: some View {
        NewReviewView(
            currentPage: .constant(.home),
            plusButtonActive: .constant(true),
            viewModel: NewReviewViewModel(
                autocompletePlacesService: PreviewAutocompletePlacesService(),
                getPlaceDetailsService: PreviewGetPlaceDetailsService(),
                fetchPlacePhotoService: PreviewFetchPlacePhotoService(),
                addReviewService: PreviewAddReviewService(),
                location: Location(latitude: 0, longitude: 0)
            ),
            selectedView: { placeDetails in
                SelectedRestaurantView(
                    viewModel: SelectedRestaurantViewModel(
                        placeDetails: placeDetails,
                        fetchPlacePhotoService: PreviewFetchPlacePhotoService()
                    )
                )
            }
        )
    }
    
    private class PreviewAutocompletePlacesService: AutocompletePlacesService {
        func autocomplete(input: String, location: Location, radius: Int) async throws -> [AutocompletePrediction] {
            let predictions = [
                AutocompletePrediction(placePrediction: "Prediction 1", placeID: "place #1"),
                AutocompletePrediction(placePrediction: "Another Pre 2", placeID: "place #2")
            ]
            
            return predictions.filter { $0.placePrediction.contains(input) }
        }
    }
    
    private class PreviewGetPlaceDetailsService: GetPlaceDetailsService {
        func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
            PlaceDetails(
                placeID: "place #1",
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
    
    private class PreviewFetchPlacePhotoService: FetchPlacePhotoService {
        func fetchPlacePhoto(photoReference: String) async throws -> Data {
            UIImage(named: "restaurant_logo_test")?.pngData() ?? Data()
        }
    }
    
    private class PreviewAddReviewService: AddReviewService {
        func addReview(placeID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {
            
        }
    }
}
