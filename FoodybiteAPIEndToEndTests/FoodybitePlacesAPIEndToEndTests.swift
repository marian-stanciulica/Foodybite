//
//  FoodybitePlacesAPIEndToEndTests.swift
//  FoodybiteAPIEndToEndTests
//
//  Created by Marian Stanciulica on 26.01.2023.
//

import XCTest
import Domain
import API_Infra
import FoodybitePlaces

final class FoodybitePlacesAPIEndToEndTests: XCTestCase {

    func test_endToEndSearchNearby_matchesFixedTestNearbyPlaces() async {
        do {
            let receivedNearbyPlaces = try await getNearbyPlaces()
            XCTAssertTrue(areEqual(first: receivedNearbyPlaces, second: expectedNearbyPlaces))
        } catch {
            XCTFail("Expected successful nearby places request, got \(error) instead")
        }
    }
    
    func test_endToEndGetPlaceDetails_matchesFixedTestPlaceDetails() async {
        do {
            let receivedPlaceDetails = try await getPlaceDetails()
            XCTAssertEqual(receivedPlaceDetails, expectedPlaceDetails)
        } catch {
            XCTFail("Expected successful nearby places request, got \(error) instead")
        }
    }
    
    func test_endToEndAutocomplete_matchesFixedTestAutocompletePredictions() async {
        do {
            let receivedAutocompletePredictions = try await autocomplete()
            XCTAssertEqual(Set(receivedAutocompletePredictions), expectedAutocompletePredictions)
        } catch {
            XCTFail("Expected successful nearby places request, got \(error) instead")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> PlacesService {
        let session = URLSession(configuration: .ephemeral)
        let httpClient = URLSessionHTTPClient(session: session)
        let loader = RemoteLoader(client: httpClient)
        return PlacesService(loader: loader)
    }
    
    private func getPlaceDetails(file: StaticString = #filePath, line: UInt = #line) async throws -> PlaceDetails {
        let apiService = makeSUT(file: file, line: line)
        return try await apiService.getPlaceDetails(placeID: "ChIJW823ek__sUARZVGTsg0Yx70")
    }
    
    private func getNearbyPlaces(file: StaticString = #filePath, line: UInt = #line) async throws -> [NearbyPlace] {
        let apiService = makeSUT(file: file, line: line)
        let location = Location(latitude: 44.441016, longitude: 26.0975475)
        let radius = 50
        return try await apiService.searchNearby(location: location, radius: radius)
    }
    
    private func autocomplete(file: StaticString = #filePath, line: UInt = #line) async throws -> [AutocompletePrediction] {
        let apiService = makeSUT(file: file, line: line)
        let input = "Trattoria"
        let location = Location(latitude: 44.441016, longitude: 26.0975475)
        let radius = 10
        return try await apiService.autocomplete(input: input, location: location, radius: radius)
    }
    
    private var expectedNearbyPlaces: [NearbyPlace] {
        [
            NearbyPlace(
                placeID: "ChIJW823ek__sUARZVGTsg0Yx70",
                placeName: "Trattoria Il Calcio Ateneu",
                isOpen: false,
                rating: 4.2,
                location: Location(latitude: 44.441016, longitude: 26.0975475),
                photo: Photo(width: 1600, height: 1063, photoReference: "AfLeUgPOZIEqo7bgl3yeMQFrosnDUOi1Z67x4Mwem_VBKOJPMyLMM6q6uArOa5Uu0U6bph2ToNq9Gql6gKWBft6-7kNjbvt_b7Kdob3jizzu4gDcTYvdJTePL0m78lxQH6l5p85OR3FMTweC6DQiIaVlcA-fwekEm80DKCNbYbycgspK4PIr")),
            NearbyPlace(
                placeID: "ChIJz7sYKOv_sUARrLLBAx36TFs",
                placeName: "MACE by Joseph Hadad",
                isOpen: true,
                rating: 4.3,
                location: Location(latitude: 44.4412386, longitude: 26.098049),
                photo: Photo(width: 7952, height: 5304, photoReference: "AfLeUgNupaTE3EI92EI3ikWp53wttMWcn-52xYfTilSfij1TFU0HT-hSZUuqG_jzyoj8buPlNwXUqhrKsuPg5Xe6DLUeZ8FYsDg1YgDIja2vBaxpYwwtyFy4G6D7UgEU394jMyXm8FDgK8ztAXnkrS58Ta9zQ97X3FyjSoL5d5c6YER3BJC4")),
            NearbyPlace(
                placeID: "ChIJ9feBck__sUARr25IXqhjG-Q",
                placeName: "Mara Mura Ateneu",
                isOpen: true,
                rating: 4.4,
                location: Location(latitude: 44.441425, longitude: 26.0978549),
                photo: Photo(width: 2048, height: 1365, photoReference: "AfLeUgOXGPzV8mw2UbsBF1gcQgomKjzRTlVZasY2lgF4Q1IsMqjsKM9GIZPccWxeMftAB4wP184XZSvfBzXwLbbi9GWrbJbK1iGC0pXoGEpGoIGMJY2Fz0YP6XhhpSNYCAeJ7YJ422r6x32DrSbBckS2IGX7g5YheThEfgN0vL_InB_JDKKe"))
        ]
    }
    
    private func areEqual(first: [NearbyPlace], second: [NearbyPlace]) -> Bool {
        guard first.count == second.count else { return false }
        
        for i in 0..<first.count {
            if first[i].placeID != second[i].placeID &&
                first[i].placeName != second[i].placeName &&
                first[i].location != second[i].location &&
                first[i].photo != second[i].photo {
                return false
            }
        }
        
        return true
    }
    
    private var expectedPlaceDetails: PlaceDetails {
        PlaceDetails(
            placeID: "ChIJW823ek__sUARZVGTsg0Yx70",
            phoneNumber: nil,
            name: "Trattoria Il Calcio Ateneu",
            address: "langa Ateneul Roman, Strada Benjamin Franklin nr 1-3, București 030167, Romania",
            rating: 4.2,
            openingHoursDetails: nil,
            reviews: [
                Review(
                    id: UUID(uuidString: "19AA1457-40CB-4FFA-BA80-B2A3532EEC72")!,
                    placeID: "ChIJW823ek__sUARZVGTsg0Yx70",
                    profileImageURL: URL(string: "https://lh3.googleusercontent.com/a-/AD5-WCmuoPq7Qv-tV7LfTiF1mZyxmrAEi_XstJvGwV12rA=s128-c0x00000000-cc-rp-mo-ba5"),
                    profileImageData: nil,
                    authorName: "Teo Gerald",
                    reviewText: "I saw good review from google map and decided to visit this restaurant. I was at the restaurant when it was not crowded. The young lady in white uniform with straight hair from counter who brought us to the seats were quite unfriendly. Not sure whether is it due to us being Asian. I noticed that she smiled to the rest but not to us.\n\nWe ordered a mushroom soup, grilled pork steak and seafood pasta. The food were good and price were very reasonable. During the lunch, I felt that the services from waiter that were more senior were less professional than the younger staff. The younger staff had smile on their faces when serving you which makes your day.\n\nAt the end of lunch, we left the restaurant seeing the young lady and she did not say goodbye, thank you or smile to us. I decided to give the restaurant 4 stars for the food and young staff who made great contributions to the restaurant. Posted picture of her at the counter if you would like to know who is her and perhaps avoid her. Overall, enjoyed myself at the restaurant. It will be great if the staff put on more smiles.",
                    rating: 4,
                    relativeTime: "4 years ago"
                ),
                Review(
                    id: UUID(uuidString: "A13A852C-2784-4F05-A3B8-11A166DC7ACE")!,
                    placeID: "ChIJW823ek__sUARZVGTsg0Yx70",
                    profileImageURL: URL(string: "https://lh3.googleusercontent.com/a-/AD5-WClGanbJiMX3rUcO4HOX_jzYVPam9tOXe6VOJayFvvA=s128-c0x00000000-cc-rp-mo"),
                    profileImageData: nil,
                    authorName: "Roberta MP",
                    reviewText: "I enjoyed my dinner at Trattoria Il Calcio. I went for dinner with some friends and we ordered pizza. As Italian I can say that it is the best one I ate here in Bucharest. I noticed that there also other good dishes and I will totally come back for dinner.",
                    rating: 5,
                    relativeTime: "11 months ago"
                ),
                Review(
                    id: UUID(uuidString: "3FC4E8FF-3957-4016-B7FB-E96D0702AB8C")!,
                    placeID: "ChIJW823ek__sUARZVGTsg0Yx70",
                    profileImageURL: URL(string: "https://lh3.googleusercontent.com/a-/AD5-WClSZj-j3ArJJVODvrbO33dGXjPvi537Jn7aQRWdrw=s128-c0x00000000-cc-rp-mo-ba3"),
                    profileImageData: nil,
                    authorName: "Voitescu Alin",
                    reviewText: "Quick table service and very fresh ingredients. The pizza was delightful, as the thin pizza dough was perfect for holding the rich flavoured ingredients on top. It was quite salty because of the Italian salami and parmigiano, so i recommend washing it down with a lot of fresh orange juice.\nNice and spacious outdoor terrace and friendly cats roaming around.",
                    rating: 5,
                    relativeTime: "3 years ago"
                ),
                Review(
                    id: UUID(uuidString: "C687B640-49D7-49F2-9243-690C0C78B374")!,
                    placeID: "ChIJW823ek__sUARZVGTsg0Yx70",
                    profileImageURL: URL(string: "https://lh3.googleusercontent.com/a/AEdFTp6JWaT3eZMQNjqrV9vMjKEtJt8iouW-huxN7N1Z=s128-c0x00000000-cc-rp-mo-ba3"),
                    profileImageData: nil,
                    authorName: "Victoria Kassis",
                    reviewText: "Nice restaurant we sat outside! It took some time after being seated for someone to come and ask us what we want to drink! Customer service was not the best so be prepared. The food was pretty good and tasty (seafood linguine and seafood risotto)",
                    rating: 4,
                    relativeTime: "3 years ago"
                ),
                Review(
                    id: UUID(uuidString: "13165133-BBE2-4F66-8D61-54511DEFA6F1")!,
                    placeID: "ChIJW823ek__sUARZVGTsg0Yx70",
                    profileImageURL: URL(string: "https://lh3.googleusercontent.com/a/AEdFTp5ViUd_CX3-otX0oXhFwHBFNL5BUbwxSDu3MLw-=s128-c0x00000000-cc-rp-mo-ba6"),
                    profileImageData: nil,
                    authorName: "Gunilla S",
                    reviewText: "A populare place with italian food on the menue. The food is good and the service is quick at first but in general not very atentiv. Can be a quite loud place especially when it is football on the screens. Great for groups and after work.",
                    rating: 4,
                    relativeTime: "4 years ago")
            ],
            location: Location(latitude: 44.441016, longitude: 26.0975475),
            photos: [
                Photo(
                    width: 1600,
                    height: 1063,
                    photoReference: "AfLeUgORJhPHc48W_JPBI6JveXHFOMz9MpTSlbyHrwA8ueBLAqyLg7IFBcWiymaAkzNx40FIMi29NS7G7_yprT0iGoQ0bfQfKSXEnE4sHPtp0x-qlyowftyYoi9_o0CuDm_HNjMxBucUcTTdzzNU9NboA70rMnD0JxAeSTuaSKsIw7mzUkNF"
                ),
                Photo(
                    width: 3024,
                    height: 4032,
                    photoReference: "AfLeUgNuYF1HeEg94l9ITLc3k-WuJAwpRAB0IhOhTtp28hYb8-EIhhwVMirhoYI_zGk4Y4udqogd-icM-IoGLtmoDZRXGj4tPKjwd1fVgQ_6TLxx7Vk3RezZaYVLuj-KusHaY6MYIAN_HrG4SEfBJiO-eRnJm3Wx1sXrHaZ8q9YDzY8UXr3P"
                ),
                Photo(
                    width: 2916,
                    height: 1820,
                    photoReference: "AfLeUgN2bRLlPUaAG7-Z7il1dez7w6wt1K-SbisABz53Io5x28UCmOlJ2g-xwB-CDqSPtpFubmqWYiRv6G3Jh5pwU-e2ST70fCCY6fwQ9AJYtKsRH0w6aBAcA112WJ3BjJ7e_8MQZ76SBE2q-qh-IrXQUvmHtD4NtuMHE1Y2qTgO-6EQlWmD"
                ),
                Photo(
                    width: 4032,
                    height: 3024,
                    photoReference: "AfLeUgPBX_txGoiqX3qWB7t8CpDE0Ue4v4y3U9McaIicp4GqkMFpupyZ2XSxms0oCNStwGQSGmp9dWl-i97_ozTwiMCcnGk29I8DmTfiTplTsiwCeQojRa_A-OxrMB6wRIS8SPrCk0c7k-5ggJ1fB-xrQGJ8RsWo2mBEHvrDzSHWvDjuOZLx"
                ),
                Photo(
                    width: 4608,
                    height: 3456,
                    photoReference: "AfLeUgNp_A2hqaPc9T90jOosar9Q7tJPcSf9VvkWvKbsIB0P5jzNSxkvwlBRVX1RQsWhUIEB-YFq2j2dZBvkiF48964xe6iFDMO7i6w_59VGiPjvgOxI-oSiOKNX_Y-hbVlMrKv3RuSGnA4BFmBV1mzrYGI6ekSV7mo-hlR6wOnENZexO7p7"
                ),
                Photo(
                    width: 4032,
                    height: 2268,
                    photoReference: "AfLeUgO8vHwlEV7ZjNmNrNThAuojnr2NS9ihafXwlRcgjyxgLMvwdLvv82wB7Z4VdtcoPh9NLeNH4RTXGYDDrM97XsR9oPP6cfvNgkTXOc_UYfNAHX5azK9ZFD5OWNfF14z22utS2AeewdvyDveJ6lRPqa2CbIgm4Uvfos16USjm5je-6n8B"
                ),
                Photo(
                    width: 3024,
                    height: 4032,
                    photoReference: "AfLeUgP0TOyZBnxs0SzyUfwXmRRw0KryQQRRikBRQpDlLEjnqbN_haSscc8JdM_dcJrg-wg_qQ8k7KHlrApXZ55d1DhDywKbLUfrJVaGMzgm-1mSh78Ucw6oJjPJZLdmOa_CxJwpYgrAZbswIO515mj8DCWIvSp3mGt5nlFltthprEUzWMLD"
                ),
                Photo(
                    width: 4032,
                    height: 3024,
                    photoReference: "AfLeUgPwcIC8YhUgF2nK--tQaV2ZuVIoT5qQkIRw4v0JAaflrPGcau7yYiIXc9LLIdUCn1wTSvLQ5o9JFcuOyYt6k-J3MSMOENEcnjVxMPNOKPbGbRrEvUNx32zYpFH5w5ZEVLNaNesgCvDg8z1Wk58zDraQxd9nKtAeTXYUndnUxmKETczR"
                ),
                Photo(
                    width: 4032,
                    height: 3024,
                    photoReference: "AfLeUgN2195-l9sq_mBT0ooUK7gu_LqsUSuQ-UaNpsNPuLbQIkOlgAHxUta8gTAjIXvWsz75eZptjnRv4uno0Ia9_PVu4_31PBkFv1eXtKXKbB2tCYS1fgYaDTDB3pU0a8L4n2LZElWBXqwIr3uQP5FQu9L-2h36LIGrtLqmXVILf04p8Qd6"
                ),
                Photo(
                    width: 3464,
                    height: 4618,
                    photoReference: "AfLeUgPS3bS-WadkHOwdyqbtbjfR4gm_pWVu3SBej6umbAR0J9U3fMBwkzyAX8Y0Fp9d5i0S8YmdXouOzI7XKi6HM9KWuXqguYEsr_wAf1Mb5_2rTMfcRXhwXtnwLn-PB1SZI0dt3uutyhRtSIbtUGKQwDp-9MhLZCx9S04v_02OP5yHJWok")
            ]
        )
    }
    
    private var expectedAutocompletePredictions: Set<AutocompletePrediction> {
        [
            AutocompletePrediction(
                placePrediction: "Trattoria Don Vito, Strada D. I. Mendeleev, Bucharest, Romania",
                placeID: "ChIJgxvxNE7_sUARNMOzDLF21PU"
            ),
            AutocompletePrediction(
                placePrediction: "Trattoria Il Calcio Ateneu, Strada Benjamin Franklin, Bucharest, Romania",
                placeID: "ChIJW823ek__sUARZVGTsg0Yx70"
            ),
            AutocompletePrediction(
                placePrediction: "Trattoria Il Calcio Magheru, Strada Anastasie Simu, Bucharest, Romania",
                placeID: "ChIJ18kE60f_sUARUUt7OD7LOVk"
            ),
            AutocompletePrediction(
                placePrediction: "Trattoria La Famiglia, Strada Nicolae Golescu, Bucharest, Romania",
                placeID: "ChIJizLJDE__sUARWSZT2x5bxhE"
            ),
            AutocompletePrediction(
                placePrediction: "Trattoria Mezzaluna, Strada Crăciun, Bucharest, Romania",
                placeID: "ChIJW1WlL634sUAR2DY7DgRv5ig"
            ),
        ]
    }
    
}
