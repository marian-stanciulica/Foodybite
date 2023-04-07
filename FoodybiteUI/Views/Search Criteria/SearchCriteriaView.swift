//
//  SearchCriteriaView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 30.05.2022.
//

import SwiftUI
import Domain
import FoodybitePresentation

public struct SearchCriteriaView: View {
    @StateObject var viewModel: SearchCriteriaViewModel
    @Environment(\.presentationMode) var presentationMode

    public init(viewModel: SearchCriteriaViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        VStack {
            HStack {
                Spacer()

                Text("Filter")
                    .font(.title)

                Spacer()

                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(.systemGray))
                }
            }
            .padding(.horizontal)

            Text("Distance")
                .font(.title)
                .padding(.top)

            SelectRadiusView(radius: $viewModel.radius)
                .padding(.bottom, 56)

            Text("Ratings")
                .font(.title)
                .padding(.top)

            RatingView(stars: $viewModel.starsNumber)

            Spacer()

            HStack {
                MarineButton(title: "Reset", isLoading: false) {
                    viewModel.reset()
                }

                MarineButton(title: "Apply", isLoading: false) {
                    viewModel.apply()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .padding()
    }
}

struct SearchCriteriaView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCriteriaView(
            viewModel: SearchCriteriaViewModel(
                userPreferences: UserPreferences(radius: 200, starsNumber: 3),
                userPreferencesSaver: PreviewUserPreferencesSaver()
            )
        )
    }

    private class PreviewUserPreferencesSaver: UserPreferencesSaver {
        func save(_ userPreferences: UserPreferences) {}
    }
}
