//
//  ProfileView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI
import Domain

struct ProfileView<Cell: View>: View {
    @StateObject var viewModel: ProfileViewModel
    let cell: (Review) -> Cell
    let goToSettings: () -> Void
    let goToEditProfile: () -> Void
    @State var editProfileAlertDisplayed = false

    var body: some View {
        ScrollView {
            VStack {
                if let imageData = viewModel.user.profileImage, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .cornerRadius(100)
                } else {
                    InitialsView(initials: String(viewModel.user.name.prefix(1)))
                        .frame(width: 150, height: 150)
                }

                Text(viewModel.user.name)
                    .font(.title)

                Text(viewModel.user.email)
                    .font(.footnote)
                    .foregroundColor(.gray)

                HStack {
                    switch viewModel.getReviewsState {
                    case .isLoading:
                        ProgressView()
                            .tint(.primary)
                    case .idle, .failure:
                        StatsView(stats: "0", description: "Reviews")
                    case let .success(reviews):
                        StatsView(stats: "\(reviews.count)", description: "Reviews")
                    }

                    Spacer()
                    Divider()
                    Spacer()

                    StatsView(stats: "0", description: "Followers")

                    Spacer()
                    Divider()
                    Spacer()

                    StatsView(stats: "0", description: "Following")
                }
                .padding(.horizontal, 56)
                .padding(.vertical)
                .task {
                    await viewModel.getAllReviews()
                }

                HStack {
                    MarineButton(title: "Edit Profile", isLoading: false) {
                        editProfileAlertDisplayed = true
                    }
                    .padding(.horizontal)

                    WhiteButton(title: "Settings") {
                        goToSettings()
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal, 32)

                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 2)
                    .foregroundColor(.gray.opacity(0.2))
                    .padding(.top)

                switch viewModel.getReviewsState {
                case .idle:
                    EmptyView()
                case .isLoading:
                    ProgressView()
                        .tint(.primary)
                case let .failure(error):
                    Text(error.rawValue)
                        .padding()
                        .foregroundColor(.red)
                        .font(.headline)
                case let .success(reviews):
                    LazyVStack {
                        ForEach(reviews, id: \.id) { review in
                            cell(review)
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Edit Profile", isPresented: $editProfileAlertDisplayed) {
                Button("Edit") { goToEditProfile() }
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteAccount()
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(
            viewModel: ProfileViewModel(
                accountService: PreviewAccountService(),
                getReviewsService: PreviewGetReviewsService(),
                user: User(id: UUID(), name: "Marian", email: "user@mail.com", profileImage: nil),
                goToLogin: {}
            ),
            cell: { review in
                RestaurantReviewCellView(
                    viewModel: RestaurantReviewCellViewModel(
                        review: review,
                        getPlaceDetailsService: PreviewGetPlaceDetailsService()
                    ),
                    makePhotoView: { _ in
                        PhotoView(
                            viewModel: PhotoViewModel(
                                photoReference: "reference",
                                fetchPhotoService: PreviewFetchPlacePhotoService()
                            )
                        )
                    },
                    showPlaceDetails: { _ in }
                )
            },
            goToSettings: {},
            goToEditProfile: {}
        )
    }
    
    private class PreviewAccountService: AccountService {
        func updateAccount(name: String, email: String, profileImage: Data?) async throws {}
        func deleteAccount() async throws {}
    }
    
    private class PreviewGetReviewsService: GetReviewsService {
        func getReviews(placeID: String?) async throws -> [Review] {
            [
                Review(placeID: "place #1", profileImageURL: nil, profileImageData: nil, authorName: "", reviewText: "", rating: 1, relativeTime: ""),
            ]
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
}
