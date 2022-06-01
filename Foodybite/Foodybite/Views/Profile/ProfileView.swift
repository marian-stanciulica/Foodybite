//
//  ProfileView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.05.2022.
//

import SwiftUI

struct ProfileView: View {
    @State private var isShowingSettings = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image("profile_picture_test")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .cornerRadius(100)

                    Text("John Williams")
                        .font(.title)

                    Text("john.williams@gmail.com")
                        .font(.body)

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

                        }
                        .padding(.horizontal)

                        NavigationLink(isActive: $isShowingSettings) {
                            SeetingsView()
                                .navigationTitle("Settings")
                        } label: {
                            WhiteButton(title: "Settings") {
                                self.isShowingSettings = true
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal, 32)

                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 2)
                        .foregroundColor(.gray.opacity(0.2))
                        .padding(.top)

                    LazyVStack {
                        ForEach(0...50, id: \.self) { _ in
                            RestaurantCell()
                                .background(.white)
                                .cornerRadius(16)
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(
                                     RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                                )
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
