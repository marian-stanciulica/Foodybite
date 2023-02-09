//
//  ProfileView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI
import Domain

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    let goToSettings: () -> Void
    let goToEditProfile: () -> Void
    @State var editProfileAlertDisplayed = false

    var body: some View {
        ScrollView {
            VStack {
                Image("profile_picture_test")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .cornerRadius(100)

                Text(viewModel.user.name)
                    .font(.title)

                Text(viewModel.user.email)
                    .font(.footnote)
                    .foregroundColor(.gray)

                HStack {
                    StatsView(stats: "250", description: "Reviews")

                    Spacer()
                    Divider()
                    Spacer()

                    StatsView(stats: "100k", description: "Followers")

                    Spacer()
                    Divider()
                    Spacer()

                    StatsView(stats: "30", description: "Following")
                }
                .padding(.horizontal, 56)
                .padding(.vertical)

                HStack {
                    MarineButton(title: "Edit Profile") {
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

//                LazyVStack {
//                    ForEach(0...50, id: \.self) { _ in
//                        RestaurantCell(
//                            viewModel: RestaurantCellViewModel(
//                                nearbyPlace: NearbyPlace(
//                                    placeID: "place id",
//                                    placeName: "place name",
//                                    isOpen: false,
//                                    rating: 4.4,
//                                    location: Location(latitude: 0, longitude: 0),
//                                    photo: nil
//                                )
//                            )
//                        )
//                        .background(.white)
//                        .cornerRadius(16)
//                        .aspectRatio(1, contentMode: .fit)
//                        .overlay(
//                             RoundedRectangle(cornerRadius: 16)
//                                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
//                        )
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 4)
//                    }
//                }
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
                user: User(id: UUID(), name: "User", email: "user@mail.com", profileImage: nil),
                goToLogin: {}
            ),
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
            []
        }
    }
}
