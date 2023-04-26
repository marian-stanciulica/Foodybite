[![CI-iOS](https://github.com/Marian25/Foodybite/actions/workflows/ios.yml/badge.svg)](https://github.com/Marian25/Foodybite/actions/workflows/ios.yml)

# Foodybite

💡 My vision for this project is centered around a simple yet powerful way to create a user-friendly app that helps you find the best restaurant near you based on location, radius, and number of stars. Additionally, users can see details, like opening hours, address, reviews, or photos for each restaurant found and give a review. The app allows users to search directly for a restaurant and enables them to give a review right away.

1. [Motivation](#motivation)
2. [Installation Guide](#installation-guide)
3. [Demo](#demo)
4. [Built With](#built-with)
5. [Architecture](#architecture)
    1. [Overview](#overview)
    2. [Domain](#domain)
        1. [User Session Feature](#1-user-session-feature)
        2. [Update/Delete Account Feature](#2-updatedelete-account-feature)
        3. [Store/Retrieve User Preferences Feature](#3-storeretrieve-user-preferences-feature)
        4. [Nearby Restaurants Feature](#4-nearby-restaurants-feature)
        5. [Fetch Restaurant Photo Feature](#5-fetch-restaurant-photo-feature)
        6. [Restaurant Details Feature](#6-restaurant-details-feature)
        7. [Autocomplete Restaurants Feature](#7-autocomplete-restaurants-feature)
        8. [Add Review Feature](#8-add-review-feature)
        9. [Get Reviews Feature](#9-get-reviews-feature)
        10. [Location Feature](#10-location-feature)
    3. [Networking](#networking)
        1. [Refresh Token Strategy](#1-refresh-token-strategy)
        2. [Network Request Flow](#2-network-request-flow)
        3. [Endpoint Creation](#3-endpoint-creation)
        4. [Testing `Data` to `Decodable` Mapping](#4-testing-data-to-decodable-mapping)
        5. [Parsing JSON Response](#5-parsing-json-response)
    4. [Places](#places)
    5. [API Infra](#api-infra)
        1. [Mock Network Requests](#mock-network-requests)
    6. [Persistence](#persistence)
        1. [Cache Domain Models](#cache-domain-models)
        2. [Infrastructure](#infrastructure)
        3. [Store User Preferences](#store-user-preferences)
    7. [Location](#location)
        1. [From delegation to async/await](#from-delegation-to-asyncawait)
        2. [Get current location using TDD](#get-current-location-using-tdd)
    8. [Presentation](#presentation)
    9. [UI](#ui)
    10. [Main](#main)
        1. [Adding caching by intercepting network requests](#adding-caching-by-intercepting-network-requests) (`Decorator Pattern`)
        2. [Adding fallback strategies when network requests fail](#adding-fallback-strategies-when-network-requests-fail) (`Composite Pattern`)
        3. [Handling navigation](#handling-navigation) (flat and hierarchical navigation)
6. [Testing Strategy](#testing-strategy)
    1. [Summary Table](#summary-table)
    2. [Methodology](#methodology)
    3. [Unit Tests](#unit-tests)
    4. [Integration Tests](#integration-tests)
        1. [End-to-End Tests](#end-to-end-tests)
        2. [Cache Integration Tests](#cache-integration-tests)
    5. [Snapshot Tests](#snapshot-tests)
7. [CI/CD](#cicd)
8. [Security](#security)
    1. [API key for Google Places API](#api-key-for-google-places-api)
    2. [Store Tokens from FoodybiteServer in Keychain](#store-tokens-from-foodybiteserver-in-keychain)
    3. [Password Hashing](#password-hashing)
9. [Metrics](#metrics)
    1. [Test lines of code per production lines of code](#test-lines-of-code-per-production-lines-of-code)
    2. [Count of files changed](#count-of-files-changed)
    3. [Code coverage](#code-coverage)
10. [Credits](#credits)
11. [References](#references)

## Motivation

The initial spark of this project originated from my desire to dive deeper into `SwiftUI` since I had already been using the framework for testing purposes and was intrigued to use it in a larger project.

Once I had completed the UI, I challenged myself to design the app in the best possible way using all the best practices in order to create a high-quality, polished project and sharpen my skills. At the same time, my interest in `TDD` and modular design were emerging, that's the reason I only used `TDD` for all modules besides the UI, which I later used for snapshot tests. 😀

Through this process, I was able to significantly improve my `TDD` skills and acknowledge its value. First of all, it helped me understand better what I was trying to achieve and have a clear picture of what I wanted to test first before writing production code. On the other hand, the architecture seemed to materialize while I was writing the tests, and by using `TDD`, I could further improve the initial design.

You can find below the entire process I've gone through while designing this project, the decisions and trade-offs regarding the architecture, testing pyramid and security issues. Additionally, I've included some really cool metrics about the evolution of the codebase.

Thank you for reading and enjoy! 🚀

## Installation Guide

### 1. Setup `Foodybite` backend
- Download [`FoodybiteServer`](https://github.com/Marian25/FoodybiteServer) locally
- Follow the instructions to run it

### 2. Get your unique `API_Key` from `Google Places`
- Go to [Google Maps Platform](https://developers.google.com/maps/documentation/places/web-service/cloud-setup) to create a project
- Create the `API_KEY` following the [Use API Keys with Places API](https://developers.google.com/maps/documentation/places/web-service/get-api-key) documentation page (make sure you restrict your key to only be used with `Places API`)
- Create a property list called `GooglePlaces-Info.plist` in the `FoodybitePlaces` framework
- Add a row with `API_KEY` and the value of your key

### 3. (Optionally) Install SwiftLint
- run the following command in the terminal to install `swiftlint`

```bash
brew install swiftlint 
```

### 4. Validate the setup
Test that everything is wired up correctly by running tests for the `FoodybiteAPIEndtoEndTests` and `CI` targets to check the communication with both backends and validate that all tests pass.

## Demo

![Profile](./Diagrams/Videos/profile.mp4)

## Built With

### Tools
✅ Xcode 14.2
✅ Swift 5.7

### Frameworks
✅ SwiftUI
✅ Combine
✅ CoreData
✅ CoreLocation

### Concepts
✅ MVVM, Clean Architecture
✅ Modular Design
✅ SOLID Principles
✅ TDD, Unit Testing, Integration Testing, Snapshot Testing
✅ Composite, Decorator Patterns
✅ Domain-Driven Design

## Architecture

### Overview

For this project, I organized the codebase into independent frameworks, using `horizontal slicing` to break down the app into layers, respecting the dependency rule:

> ❗️ High-level modules should not depend on lower-level modules and lower-level modules should only communicate and know about the next higher-level layer.

In my opinion, it's the best approach for this kind of project since `vertical slicing` is more suitable for larger projects with feature teams. Also, the number of features isn't high enough to make the layers bloated with an excessive number of classes and become unmanageable.

The following diagram provides a top-level view with all modules from this project along with their dependencies on other modules:
1. [Domain](#domain)
2. [Networking](#networking)
3. [Places](#places)
4. [API Infra](#api-infra)
5. [Persistence](#persistence)
6. [Location](#location)
7. [Presentation](#presentation)
8. [UI](#ui)
9. [Main](#main)

![Top Level Modules](./Diagrams/Top_Level_View_Modules.svg)

### Domain

The domain represents the innermost layer in the architecture (no dependencies with other layers). It contains only models and abstractions for:
- fetching or saving data implemented by the [Networking](#networking), [Places](#places), and [Persistence](#persistence) modules
- providing the current location implemented by the [Location](#location) module
- the [Presentation](#presentation) module to obtain relevant data and convert it to the format required by the [UI](#ui) module

#### 1. User Session Feature

```swift
public struct User: Equatable {
    public let id: UUID
    public let name: String
    public let email: String
    public let profileImage: Data?
    
    public init(id: UUID, name: String, email: String, profileImage: Data?) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImage = profileImage
    }
}
```

```swift
public protocol SignUpService {
    func signUp(name: String, email: String, password: String, confirmPassword: String, profileImage: Data?) async throws
}

public protocol LoginService {
    func login(email: String, password: String) async throws -> User
}

public protocol LogoutService {
    func logout() async throws
}
```

#### 2. Update/Delete Account Feature

```swift
public protocol AccountService {
    func updateAccount(name: String, email: String, profileImage: Data?) async throws
    func deleteAccount() async throws
}

public protocol ChangePasswordService {
    func changePassword(currentPassword: String, newPassword: String, confirmPassword: String) async throws
}
```

#### 3. Store/Retrieve User Preferences Feature

```swift
public struct UserPreferences: Equatable {
    public let radius: Int
    public let starsNumber: Int
    
    public static let `default` = UserPreferences(radius: 10_000, starsNumber: 0)
    
    public init(radius: Int, starsNumber: Int) {
        self.radius = radius
        self.starsNumber = starsNumber
    }
}
```

```swift
public protocol UserPreferencesSaver {
    func save(_ userPreferences: UserPreferences)
}

public protocol UserPreferencesLoader {
    func load() -> UserPreferences
}
```

#### 4. Nearby Restaurants Feature

```swift
public struct NearbyRestaurant: Equatable {
    public let id: String
    public let name: String
    public let isOpen: Bool
    public let rating: Double
    public let location: Location
    public let photo: Photo?
}

public struct Location: Equatable, Hashable {
    public let latitude: Double
    public let longitude: Double
}
```

```swift
public protocol NearbyRestaurantsService {
    func searchNearby(location: Location, radius: Int) async throws -> [NearbyRestaurant]
}

public protocol NearbyRestaurantsCache {
    func save(nearbyRestaurants: [NearbyRestaurant]) async throws
}
```

#### 5. Fetch Restaurant Photo Feature

```swift
public struct Photo: Equatable, Hashable {
    public let width: Int
    public let height: Int
    public let photoReference: String
}
```

```swift
public protocol RestaurantPhotoService {
    func fetchPhoto(photoReference: String) async throws -> Data
}
```

#### 6. Restaurant Details Feature

```swift
public struct RestaurantDetails: Equatable, Hashable {
    public let id: String
    public let phoneNumber: String?
    public let name: String
    public let address: String
    public let rating: Double
    public let openingHoursDetails: OpeningHoursDetails?
    public var reviews: [Review]
    public let location: Location
    public let photos: [Photo]
}

public struct OpeningHoursDetails: Equatable, Hashable {
    public let openNow: Bool
    public let weekdayText: [String]
}

public struct Review: Equatable, Identifiable, Hashable {
    public var id: UUID
    public let restaurantID: String
    public let profileImageURL: URL?
    public let profileImageData: Data?
    public let authorName: String
    public let reviewText: String
    public let rating: Int
    public let relativeTime: String
}
```

```swift
public protocol RestaurantDetailsService {
    func getRestaurantDetails(restaurantID: String) async throws -> RestaurantDetails
}

public protocol RestaurantDetailsCache {
    func save(restaurantDetails: RestaurantDetails) async throws
}
```

#### 7. Autocomplete Restaurants Feature

```swift
public struct AutocompletePrediction: Hashable {
    public let restaurantPrediction: String
    public let restaurantID: String
}
```

```swift
public protocol AutocompleteRestaurantsService {
    func autocomplete(input: String, location: Location, radius: Int) async throws -> [AutocompletePrediction]
}
```

#### 8. Add Review Feature

```swift
public struct Review: Equatable, Identifiable, Hashable {
    public var id: UUID
    public let restaurantID: String
    public let profileImageURL: URL?
    public let profileImageData: Data?
    public let authorName: String
    public let reviewText: String
    public let rating: Int
    public let relativeTime: String
}
```

```swift
public protocol AddReviewService {
    func addReview(restaurantID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws
}
```

#### 9. Get Reviews Feature

```swift
public struct Review: Equatable, Identifiable, Hashable {
    public var id: UUID
    public let restaurantID: String
    public let profileImageURL: URL?
    public let profileImageData: Data?
    public let authorName: String
    public let reviewText: String
    public let rating: Int
    public let relativeTime: String
}
```

```swift
public protocol GetReviewsService {
    func getReviews(restaurantID: String?) async throws -> [Review]
}

public protocol ReviewCache {
    func save(reviews: [Review]) async throws
}
```

#### 10. Location Feature

```swift
public struct Location: Equatable, Hashable {
    public let latitude: Double
    public let longitude: Double
}
```

```swift
public protocol LocationProviding {
    var locationServicesEnabled: Bool { get }
    
    func requestWhenInUseAuthorization()
    func requestLocation() async throws -> Location
}
```

### Networking
The following diagram showcases the networking layer, which communicates with my backend app. For a better understanding, I will elaborate each major section of the diagram and decisions made during testing:
1. [Refresh Token Strategy](#1-refresh-token-strategy)
2. [Network Request Flow](#2-network-request-flow)
3. [Endpoint Creation](#3-endpoint-creation)
4. [Testing `Data` to `Decodable` Mapping](#4-testing-data-to-decodable-mapping)
5. [Parsing JSON Response](#5-parsing-json-response)

![Networking Diagram](./Diagrams/Networking.svg)

| Component | Responsibility |
|------|------|
| KeychainTokenStore | Performs read/write operations from/to Keychain on AuthToken |
| RefreshTokenService | Fetches new `AuthToken` from server and stores it in `TokenStore` |
| RefreshTokenEndpoint | Creates `URLRequest` for generating new access and refresh tokens |
| AuthToken | Struct containing accessToken and refreshToken |
| AuthenticatedURLSessionHTTPClient | Decorator over `HTTPClient` that adds authentication capability to the client |
| RemoteStore | Validates the response from `HTTPClient` and parses the data |
| APIService | Creates the endpoints and sends them to the `ResourceLoader` or `ResourceSender` |
| LoginEndpoint | Creates `URLRequest` for authentication |
| SignUpEndpoint | Creates `URLRequest` for creating an account |
| AccountEndpoint | Creates `URLRequest` for updating the current account or deleting it |
| LogoutEndpoint | Creates `URLRequest` for ending the current session |
| ChangePasswordEndpoint | Creates `URLRequest` for changing the password |
| ReviewEndpoint | Creates `URLRequest` for adding a review or getting all reviews for a particular restaurant |

#### 1. Refresh Token Strategy

The following diagram outlines the entire state machine of making requests that require authentication.

![Refresh Token State Machine](./Diagrams/Refresh_Token_State_Machine.svg)

In order to avoid making multiple `refreshTokens` requests in parallel, I stored the first task in an instance property. The first request creates the task and the following requests are just waiting for the task value (in this case, the value is `Void`, so they only waits for the completion of the task).

```swift
public func fetchLocallyRemoteToken() async throws {
    if let refreshTask = refreshTask {
        return try await refreshTask.value
    }
    
    let urlRequest = try createURLRequest()
    
    let task: Task<Void, Error> = Task {
        let remoteAuthToken: AuthToken = try await loader.get(for: urlRequest)
        try tokenStore.write(remoteAuthToken)
        
        refreshTask = nil
    }
    
    refreshTask = task
    try await task.value
}
```

To validate that only one request is actually made when multiple requests are triggered in parallel, I utilized a `TaskGroup` to simulate this behaviour and ensure that all subsequent requests received the token stored by the first request.

```swift
func test_fetchLocallyRemoteToken_makesRefreshTokenRequestOnlyOnceWhenCalledMultipleTimesInParallel() async throws {
    let (sut, loaderSpy, _) = makeSUT(authToken: makeRemoteAuthToken())
    
    await requestRemoteAuthTokenInParallel(on: sut, numberOfRequests: 10)
    
    XCTAssertEqual(loaderSpy.requests.count, 1)
}

private func requestRemoteAuthTokenInParallel(on sut: TokenRefresher, numberOfRequests: Int) async {
    await withThrowingTaskGroup(of: Void.self) { group in
        (0..<numberOfRequests).forEach { _ in
            group.addTask {
                try await sut.fetchLocallyRemoteToken()
            }
        }
    }
}
```

Additionally, to prevent potential race conditions that can occur while mutating the `refreshTask` instance property from different threads, I decided to implement the `RefreshTokenService` as an actor. Also, the actor is instantiated in the composition root only once (singleton lifetime), preventing multiple instances to make concurrent `refreshTokens` requests.

```swift
public actor RefreshTokenService: TokenRefresher {
    private let loader: ResourceLoader
    private let tokenStore: TokenStore
    private var refreshTask: Task<Void, Error>?
    ...
}
```

#### 2. Network Request Flow

This flow is composed by 3 classes: 
- `APIService`, which implements domain protocols, creates `URLRequest` objects from endpoints and sends them to the remote store.
- `RemoteStore`, which implements `ResourceLoader` and `ResourceSender`, validates the status code returned by the client and parses received data.
- `AuthenticatedURLSessionHTTPClient`, which decorates `HTTPClient`, signs each request with an access token fetched using an `TokenRefresher` collaborator (You can find more details about refresh token strategy [here](#1-refresh-token-strategy)). In the `Composition Root`, this class is used only for requests that require authentication, otherwise an instance of `URLSessionHTTPClient` from the `API Infra` module is used.

![AuthenticatedURLSessionHTTPClient](./Diagrams/AuthenticatedURLSessionHTTPClient.svg)

#### 3. Endpoint Creation

Initially, I created a single enum with individual cases for each request which conformed to the `Endpoint` protocol. It was a convenient choice because all requests available were grouped in a single file. However, as I was adding more requests, I recognised that each time the same file was modified, thus breaking the `Open/Closed Principle` which states that the system should be open for extension, but closed for modification.

I immediately pivoted and extracted the initial cases in separate enums with related requests, such as with the `AccountEndpoint` which has cases for `POST` and `DELETE`.

```swift
enum AccountEndpoint: Endpoint {
    case post(UpdateAccountRequestBody)
    case delete
    
    var path: String {
        "/auth/account"
    }
    
    var method: RequestMethod {
        switch self {
        case .delete:
            return .delete
        case .post:
            return .post
        }
    }
    
    var body: Encodable? {
        switch self {
        case let .post(updateAccountBody):
            return updateAccountBody
        case .delete:
            return nil
        }
    }
}
```

Otherwise, if a request is not related to any other requests, I extracted it into a separate struct with an instance property representing the body of the request.

```swift
struct LoginEndpoint: Endpoint {
    private let requestBody: LoginRequestBody
    
    init(requestBody: LoginRequestBody) {
        self.requestBody = requestBody
    }

    var path: String {
        "/auth/login"
    }
    
    var method: RequestMethod {
        .post
    }
    
    var body: Encodable? {
        requestBody
    }
}
```
Currently, when the need to add another endpoint arises, I can only create another struct which conforms to `Endpoint` or edit a file containing related endpoints to the one I want to add (this case still violates the principle, but considering the relatedness of the endpoints I think it's a good trade-off for now).

#### 4. Testing `Data` to `Decodable` Mapping

For testing the mapping from `Data` to `Decodable` I preferred to test it directly in the `RemoteStore`, hiding the knowledge of a collaborator (in this case `CodableDataParser`). While I could have accomplished this using a stubbed collaborator (e.g. a protocol `DataParser`), I prefered to test it in integration, resulting in lower complexity and coupling of tests with the production code.

#### 5. Parsing JSON Response

To parse the JSON received from the server I had two alternatives:
1. To make domain models conform to `Codable` and use them directly to decode the data
2. Create distinct representation for each domain model that needs to be parsed

I ended up choosing the second approach as I didn't want to leak the details of the concrete implementation outside of the module because it would reduce its encapsulation by letting other modules know how JSON parsing is performed.

### Places

The following diagram depicted below represents the `Places` module. This module has been designed to adhere to the `Single Responsibility Principle` by isolating the requests to my server from the ones that communicates with [`Google Places APIs`](https://developers.google.com/maps/documentation/places/web-service/overview).

![Places](./Diagrams/Places.svg)

| Component | Responsibility |
|------|------|
| RemoteLoader | Validates the response from `HTTPClient` and parses the data or returns it directly |
| PlacesService | Creates the endpoints and sends them to the `ResourceLoader` or `DataLoader` |
| SearchNearbyEndpoint | Creates `URLRequest` for searching nearby restaurants |
| GetRestaurantDetailsEndpoint | Creates `URLRequest` for getting detailed information about a particular restaurant |
| GetPlacePhotoEndpoint | Creates `URLRequest` for fetching image data using a photo reference |
| AutocompleteEndpoint | Creates `URLRequest` for searching restaurants given an input, location and radius |

#### Parsing JSON Response

The [same argument](#5-parsing-json-response) for the `Networking` module is also valid in this context. Additionally, I included in the DTOs all fields made available by the `Google Places API` for the convenience of checking easily what fields are available for each request to use them for developing the features without checking the documentation all the time.

### API Infra

The following diagram contains the concrete implementation of the `HTTPClient` protocol utilizing `URLSession`. It respects the dependency rule outlined in the overview section, as it solely depends on the `Networking` and `Places` modules. The decision to extract the infrastructure class in a separate module and compose them in the `Composition Root` was made due to the fact that both modules require to make network requests.

![API Infra](./Diagrams/API_Infra.svg)

#### Mock Network Requests

It's not recommended to hit the network while testing the `URLSessionHTTPClient` in isolation. For checking the actual communication, I used [end-to-end tests](#end-to-end-tests) to validate the integration of the networking modules with the backend. In my experience, there are 3 methods to mock a network request which uses `URLSession`:

1. By creating a spy/stub class for `URLSession`, overriding the following method to return stubbed data or capturing the parameters.

```swift
func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
```

> 🚩 There are many more methods in the `URLSession` class that we don't control and by subclassing we assume the behaviour of the overridden method is not depending on other methods.

2. By creating a protocol with only the method we are interested in mocking and making `URLSession` conform to it. Furthermore, we can implement our spy/stub using the protocol.

```swift
public protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
```

> 🚩 The need to create the protocol in production for the sole purpose of testing because it's not an abstraction meant to be used by clients.

3. By subclassing `URLProtocol` and overriding several methods to intercept the requests. 


Also, the stub should be registered for the `URL Loading System` to use it by calling `URLProtocol.registerClass(URLProtocolStub.self)` or set it directly in the `protocolClasses` property of `URLSessionConfiguration` before instantiating the session. To instantiate `URLSessionHTTPClient` for testing, I utilized the following factory method:

```swift
private func makeSUT() -> URLSessionHTTPClient {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [URLProtocolStub.self]
    let session = URLSession(configuration: configuration)
    let sut = URLSessionHTTPClient(session: session)
    return sut
}
```

For this project, I opted out to use the third option as it's the most reliable and doesn't require the creation of additional files exclusively for testing, thus cluttering the production side. I also use a struct to stub fake responses in the client and an array to spy on the incoming `URLRequests`. 

It's critical to remove the stub after each test not to influence the initial state of the other tests since the properties are static and shared between them. They are static because the `URLProtocolStub` can't be instantiated directly, as the system handles it internally. Thus, I don't have direct access to an instance, so I must use static properties to inject fake responses and spy the incoming requests.

```swift
class URLProtocolStub: URLProtocol {
    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }
    
    private static var stub: Stub?
    private(set) static var capturedRequests = [URLRequest]()
    
    static func stub(data: Data?, response: URLResponse?, error: Error?) {
        stub = Stub(data: data, response: response, error: error)
    }
    
    static func removeStub() {
        stub = nil
        capturedRequests = []
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        capturedRequests.append(request)
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let stub = URLProtocolStub.stub else { return }
        
        if let data = stub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = stub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = stub.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {}
}
```

### Persistence

The following diagram presents the `Persistence` module and highlights the [infrastructure](#infrastructure) to [cache domain models](#cache-domain-models) in `CoreData`. Additionaly, it has the capability to [store `UserPreferences`](#store-user-preferences) locally in `UserDefaults`. 

![Persistence](./Diagrams/Persistence.svg)

| Component | Responsibility |
|------|------|
| LocalUserPreferences | Local representation of `UserPreferences` |
| UserPreferencesLocalStore | Uses `UserDefaults` to store and retrieve `UserPreferences` models |
| UserDAO | Uses `LocalStore` to save or retrieve a user |
| NearbyRestaurantsDAO | Uses `LocalStore` to save or retrieve nearby restaurants |
| RestaurantDetailsDAO | Uses `LocalStore` to save or retrieve restaurant details |
| CoreDataLocalStore | `CoreData` implementation of `LocalStore` that writes or reads objects which conforms to `LocalModelConvertable` |
| LocalModelConvertable | Generic protocol that creates a one-to-one relationship between a domain and managed model |

#### Cache Domain Models

To enhance the system's maintainability, I decoupled the use cases from the implementation details by applying the `Dependency Inversion` technique, creating the `LocalStore` protocol and making the concrete implementation of the local store to satisfy the use cases requirements (all the `DAO` classes). 

This helps to achieve a better separation of concerns (not exposing managed object contexts or entities as parameters) and allows the replacement of the infrastructure implementation without affecting other components. Thus, if I have the need to replace `CoreData` in the future with other persistence frameworks like `Realm` or have just an in-memory cache, it will be fairly simple. Additionally, in the case of new requirements coming in, I won't be concerned over the inner workings of the actual store, as long as the `LocalStore` protocol satisfy the requirements.

For my current use cases, I only need to write/read one object or more from the local store.

```swift
public protocol LocalStore {
    func read<T: LocalModelConvertable>() async throws -> T
    func readAll<T: LocalModelConvertable>() async throws -> [T]
    func write<T: LocalModelConvertable>(_ object: T) async throws
    func writeAll<T: LocalModelConvertable>(_ objects: [T]) async throws
}
```

#### Infrastructure

Initially, I needed to cache only the `User` model for the autologin feature. In order to save users in the `CoreData` store an `NSManagedObject` is required. So, I had two options:
1. Make the domain model inherit `NSManagedObject`

| Advantages | Disadvantages |
|------|------|
| It's really convenient to make the `User` domain model inherit from `NSManagedObject` | All modules that depend on `Domain` would depend on an implementation detail of the `Persistence` module, thus coupling the business logic with a specific framework (leaking framework details) |
| | It increases the number of components that depends on the domain model making any future change to it an expensive process, as it could potentially break several modules |
| | All the following decisions would be made by trying to accomodate the coupling with `CoreData` |

2. Create a distinct representation of an user model specific for `CoreData`

| Advantages | Disadvantages |
|------|------|
| It increases modularity by hiding the implementation details for the `CoreData` store | Requires creating another model, also mapping back and forth from the domain model |
| It's not forcing the domain model to contain properties relevant only for persistence (e.g. relationships) | |
| Working with structs (immutable data) can be easier to comprehend than with classes (mutable references) | |

Since I wanted to hide all implementation details related to persistence, maintain modularity and decrease the coupling of domain models with a specific framework, I decided to create a separate managed model corresponding to the `User` domain model.

After creating distinct representation for all domain models, to establish a one-to-one relationship between domain and managed models, I developed a generic protocol, for domain models to implement, with requirements for mapping between the two models.

```swift
public protocol LocalModelConvertable {
    associatedtype LocalModel: NSManagedObject
    
    init(from: LocalModel)
    func toLocalModel(context: NSManagedObjectContext) -> LocalModel
}
```

The initial goal was to establish a generic boundary for the concrete implementation to use the same store for all domain models, that's why the `LocalStore` contains generic methods dependent on types that must conform to `LocalModelConvertable`. Also, the mapping is done in the concrete implementation (`CoreDataLocalStore`) which adheres to the `Open/Closed Principle` because adding a new managed model doesn't require any change in the concrete store, but only creating the managed model and conforming the domain model to the `LocalModelConvertable` to create the relationship between them. The following code block is an example for the `User` model:

```swift
extension User: LocalModelConvertable {
    public init(from managedUser: ManagedUser) {
        self.init(id: managedUser.id,
                  name: managedUser.name,
                  email: managedUser.email,
                  profileImage: managedUser.profileImage)
    }
    
    public func toLocalModel(context: NSManagedObjectContext) -> ManagedUser {
        ManagedUser(self, for: context)
    }
}
```

#### Store User Preferences

I decided to create a local representation of user preferences locally to hide the `Codable` dependency from the domain model and avoid all the complexity that may arise from it. It's the same reasoning as for the `CoreData` local store mentioned earlier (hiding implementation details because clients don't care how the data is actually stored). This gives me the flexibility to change the underlying implementation to better suit the new requirements (maybe moving user preferences in a `CoreData` store or choosing other way of persisting data).

### Location

The following diagram presents the `Location` module and how it interacts with `CoreLocation`.

In this module, I decided to switch from the classic delegation pattern of getting the current location to the `async/await` approach using a continuation (You can find more details about it here: [From delegation to async/await](#from-delegation-to-asyncawait)).

Another interesting topic related to this module is getting the current location using `CLLocationManager` and `CLLocationManagerDelegate` while doing `TDD`. (More details here: [Get current location using TDD](#get-current-location-using-tdd))

![Location](./Diagrams/Location.svg)

| Component | Responsibility |
|------|------|
| LocationProvider | Fetches user's current location |
| DistanceSolver | Computes distance between two locations |

#### From delegation to async/await

Since all modules use the `async/await` concurrency module, I needed to switch from the usual delegation pattern that `CoreLocation` uses to advertise the current location.

I was able to do it by using a continuation which I captured in the `requestLocation` method in `LocationProvider` only if the user previously authorized the use of the location. Afterwards, I make the request for a single location to the location manager.

```swift
public func requestLocation() async throws -> Location {
    guard locationServicesEnabled else {
        throw LocationError.locationServicesDisabled
    }
    
    return try await withCheckedThrowingContinuation { continuation in
        self.continuation = continuation
        locationManager.requestLocation()
    }
}
```

At this moment, we need to wait for a delegate method to be triggered to resume the continuation either with an error or with a location.

```swift
public func locationManager(manager: LocationManager, didFailWithError error: Error) {
    continuation?.resume(throwing: error)
    continuation = nil
}

public func locationManager(manager: LocationManager, didUpdateLocations locations: [CLLocation]) {
    if let firstLocation = locations.first {
        let location = Location(
            latitude: firstLocation.coordinate.latitude,
            longitude: firstLocation.coordinate.longitude
        )
        continuation?.resume(returning: location)
        continuation = nil
    }
}
```

> ❗️ Resuming a continuation must be made exactly once. Otherwise, it results in undefined behaviour, that's why I set it to nil after each resume call, to prevent calling it on the same instance again. Not calling it leaves the task in a suspended state indefinitely. (Apple docs: [CheckedContinuation](https://developer.apple.com/documentation/swift/checkedcontinuation))

#### Get current location using TDD

To effectively test the behaviour of the `LocationProvider` in isolation, I needed to decouple it from `CoreLocation`. Before starting the TDD process, I had quickly written an experimental class (without commiting it) to determine the necessary location features and how the component would interact with `CoreLocation`.

During the experimentation, I discovered the need to mock the behaviour of the `CLLocationManager` class in order to spy certain behaviours (e.g. `requestLocation()`) or stub properties (e.g. `authorizationStatus`). Another reason for this is that `CoreLocation` requires user authorization, which can trigger a permission dialog on the device if it hasn't been granted before, making the tests reliant on device state and causing them to be less maintainable and more prone to failure.

A common practice in this case is to extract a protocol with properties and methods from the target class, in this case `CLLocationManager`, that I was interested in mocking during testing. You can see below the minimal protocol for requesting the user's authorization and the current location.

```swift
public protocol LocationManager {
    var locationDelegate: LocationManagerDelegate? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }

    func requestWhenInUseAuthorization()
    func requestLocation()
}

```

Next, I used an extension to make `CLLocationManager` conform to this protocol, allowing me to use the protocol instead of the concrete implementation of the location manager in production.

```swift
extension CLLocationManager: LocationManager {}
```

On the other hand, I could use it to create a spy for this collaborator to test how it interacts with the SUT by spying methods or stubbing properties.

```swift
private class LocationManagerSpy: LocationManager {
    var delegate: CLLocationManagerDelegate?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    var requestWhenInUseAuthorizationCallCount = 0
    var requestLocationCallCount = 0
    
    func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationCallCount += 1
    }
    
    func requestLocation() {
        requestLocationCallCount += 1
    }
}
```

I needed to decouple the code from the other external dependency, `CLLocationManagerDelegate`, by creating a protocol that mimicks it, but uses the protocol for the manager defined above.

```swift
public protocol LocationManagerDelegate: AnyObject {
    func locationManagerDidChangeAuthorization(manager: LocationManager)
    func locationManager(manager: LocationManager, didFailWithError error: Error)
    func locationManager(manager: LocationManager, didUpdateLocations locations: [CLLocation])
}
```

`LocationProvider` needs to conform to this new protocol and implement the logic required for fetching the current location. Additionally, it still needs to conform to `CLLocationManagerDelegate` because the concrete implementation, `CLLocationManager`, is not aware of the `LocationManagerDelegate` existence, but those methods only need to call their equivalent method.

```swift
extension LocationProvider: LocationManagerDelegate  {
    public func locationManagerDidChangeAuthorization(manager: LocationManager) {
        // some more code
    }
    
    public func locationManager(manager: LocationManager, didFailWithError error: Error) {
        // some more code
    }
    
    public func locationManager(manager: LocationManager, didUpdateLocations locations: [CLLocation]) {
        // some more code
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManagerDidChangeAuthorization(manager: manager)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager(manager: manager, didFailWithError: error)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager(manager: manager, didUpdateLocations: locations)
    }
}
```

### Presentation

This layer makes the requests for getting data using a service and it formats the data exactly how the `UI` module requires it.

By decoupling view models from the concrete implementations of the services allowed me to simply add the caching and the fallback features later on without changing the view models and shows how the view models conform to the `Open/Closed Principle`. Additionally, since I created separate abstractions for each request, I was able to gradually add functionalities. For this reason, each view model has access to methods it only cares about, thus respecting the `Interface Segregation Principle` and making the concrete implementations depend on the clients' needs as they must conform to the protocol.

On the other side, adding all methods in a single protocol would have resulted in violating the `Single Responsibility Principle`, making the protocol bloated and forcing the clients to implement methods they don't care about. It's also a violation of the `Liskov Substitution Principle` if the client crashes the app when it doesn't know how to handle that behaviour or simply don't care about implementing it.

Thus, by introducing abstractions, I increased the testability of the view models since mocking their collaborators during testing is a lot easier.

### UI

The following diagram is the tree-like representation of all the screens in the app. To increase the reusability of views, I made the decision to move the responsibility of creating subviews to the layer above, meaning the composition root. Additionally, I decoupled all views from the navigation logic by using closures to trigger transitions between them (More details in the [Main](#main) section).

The best example is the `HomeView` which is defined as a generic view requiring:
- one closure to signal that the app should navigate to the restaurant details screen (the view being completely agnostic on how the navigation is done)
- one closure that receives a `NearbyRestaurant` and returns a `Cell` view to be rendered (the view is not responsible for creating the cell and doesn't care what cell it receives)
- one closure that receives a binding to a `String` and returns a view for searching nearby restaurants

Furthermore, I avoid making views to depend on their subviews' dependencies by moving the responsibility of creating its subviews to the composition root. Thus, I keep the views constructors containing only dependencies they use.

```swift
struct HomeView<Cell: View, SearchView: View>: View {
    let showRestaurantDetails: (String) -> Void
    let cell: (NearbyRestaurant) -> Cell
    let searchView: (Binding<String>) -> SearchView
    ...
```

![Screen Hierarchy](./Diagrams/Screen_Hierarchy.svg)

### Main

This module is responsible for instantiation and composing all independent modules in a centralized location which simplifies the management of modules, components and their dependencies, thus removing the need for them to communicate directly, increasing the composability and extensibility of the system (`Open/Closed Principle`).

Moreover, it represents the composition root of the app and handles the following responsiblities:
1. [Adding caching by intercepting network requests](#adding-caching-by-intercepting-network-requests) (`Decorator Pattern`)
2. [Adding fallback strategies when network requests fail](#adding-fallback-strategies-when-network-requests-fail) (`Composite Pattern`)
3. [Handling navigation](#handling-navigation) (flat and hierarchical navigation)

#### Adding caching by intercepting network requests

One extremely beneficial advantage of having a composition root is the ability to inject behaviour into an instance without changing its implementation using the `Decorator` pattern. I use it to intercept the requests and save the received domain models in the local store.

The following is an example of how I applied the pattern to introduce the caching behaviour after receiving the nearby restaurants. The decorator just conforms to the protocol that the decoratee conforms to and has an additional dependency, the cache, for storing the objects.

```swift
public final class NearbyRestaurantsServiceCacheDecorator: NearbyRestaurantsService {
    private let nearbyRestaurantsService: NearbyRestaurantsService
    private let cache: NearbyRestaurantsCache
    
    public init(nearbyRestaurantsService: NearbyRestaurantsService, cache: NearbyRestaurantsCache) {
        self.nearbyRestaurantsService = nearbyRestaurantsService
        self.cache = cache
    }
    
    public func searchNearby(location: Location, radius: Int) async throws -> [NearbyRestaurant] {
        let nearbyRestaurants = try await nearbyRestaurantsService.searchNearby(location: location, radius: radius)
        try? await cache.save(nearbyRestaurants: nearbyRestaurants)
        return nearbyRestaurants
    }
}
```

I did the same for caching details and reviews for a given restaurant.

#### Adding fallback strategies when network requests fail

The `Composite` pattern is an effective way to compose multiple implementations of a particular abstraction, executing the first strategy that doesn't fail.

The following is an example of how I composed two strategies of fetching nearby restaurants using the `NearbyRestaurantsService` abstraction. I composed two abstractions instead of using concrete types to easily test the composite in isolation and increase the flexibility of the composition as it's not bounded to a given implementation. 

```swift
public final class NearbyRestaurantsServiceWithFallbackComposite: NearbyRestaurantsService {
    private let primary: NearbyRestaurantsService
    private let secondary: NearbyRestaurantsService
    
    public init(primary: NearbyRestaurantsService, secondary: NearbyRestaurantsService) {
        self.primary = primary
        self.secondary = secondary
    }
    
    public func searchNearby(location: Location, radius: Int) async throws -> [NearbyRestaurant] {
        do {
            return try await primary.searchNearby(location: location, radius: radius)
        } catch {
            return try await secondary.searchNearby(location: location, radius: radius)
        }
    }
}
```

In this manner, I can introduce multiple retries of requests until I end up loading the data from the local store. For now, I only try the network request once and then I fetch the data from cache.

```swift
lazy var nearbyRestaurantsServiceWithFallbackComposite = NearbyRestaurantsServiceWithFallbackComposite(
    primary: NearbyRestaurantsServiceCacheDecorator(
        nearbyRestaurantsService: placesService,
        cache: nearbyRestaurantsDAO
    ),
    secondary: nearbyRestaurantsDAO
)
```

I similarly composed the `RestaurantDetailsService` and `GetReviewsService` protocols.

#### Handling navigation

##### Flat Navigation

I created a custom tab bar to handle the flat navigation by using a `TabRouter` observable object to navigate at the corresponding page when the user taps on a tab icon. The `Page` enum holds cases for all the available tabs.

```swift
class TabRouter: ObservableObject {
    enum Page {
        case home
        case newReview
        case account
    }
    
    @Published var currentPage: Page = .home
}
```

Each view presented in the tab bar is wrapped in a `TabBarPageView` container. Creating a new view is a matter of adding a new case in the `Page` enum and wrapping the view in the tab bar while switching through the current page.

##### Hierarchical Navigation

To implement this kind of navigation, I used the new `NavigationStack` type introduced in iOS 16. Firstly, I created a generic `Flow` class that can append or remove a new route.

```swift
final class Flow<Route: Hashable>: ObservableObject {
    @Published var path = [Route]()
    
    func append(_ value: Route) {
        path.append(value)
    }
    
    func navigateBack() {
        path.removeLast()
    }
}
```

Secondly, I created enums for each navigation path. For instance, from the `Home` screen, the user can navigate to the `Restaurant Details` screen and then to the `Add Review` screen. Therefore, all reachable screens are the following (I used the associated value of a case to send additional information between screens. In this case, it's the restaurant ID.):

```swift
public enum HomeRoute: Hashable {
    case restaurantDetails(String)
    case addReview(String)
}
```

Furthermore, I used the `navigationDestination(for:destination:)` modifier to define links between the root view and the destination based on the route. The following example is the instantiation of the `HomeView` and definition of its navigation destinations:

```swift
@ViewBuilder func makeHomeFlowView(currentLocation: Location) -> some View {
    NavigationStack(path: $homeFlow.path) {
        TabBarPageView(page: $tabRouter.currentPage) {
            HomeFlowView.makeHomeView(
                ...
            )
        }
        .navigationDestination(for: HomeRoute.self) { route in
            switch route {
            case let .restaurantDetails(restaurantID):
                HomeFlowView.makeRestaurantDetailsView(
                    ...
                )
            case let .addReview(restaurantID):
                HomeFlowView.makeReviewView(
                    ...
                )
            }
        }
    }
}

@ViewBuilder func makeRestaurantDetailsView(flow: Flow<HomeRoute>, ...) -> some View {
    RestaurantDetailsView(..., showReviewView: {
        flow.append(.addReview(restaurantID))
    })
}
```

The navigation stack wraps a `TabBarPageView` that contains `HomeView`. Depending on the current case of `HomeRoute`,  the corresponding view is instantiated. Moreover, the factory method that instantiates `RestaurantDetailsView` requires a closure in its constructor for navigating to the `Add Review` screen.

I handled all the hierarchical navigation throughout the app, which allowed me to change the screens order from the composition root without affecting other modules. In addition, it improves the overall flexibility and modularity of the system, as the views don't have knowledge about the navigation implementation.

## Testing Strategy

Throughout the entire project, I've used `TDD` as the development process (excluding the UI layer) by following the feedback loop.

Having used `TDD` for over a year, I really enjoy how it allows me to break down tasks and solve one problem at a time. Also, I find it interesting how the design evolves naturally when using `TDD`. Additionally, it has helped me understand better what I was trying to build before writing code while increasing my confidence in the system's correctness.

The foundation for my testing strategy was unit tests for the system internals (without hitting external systems like the network or the disk). In addition, I wrote `End-to-End` tests to test the integration with the network infrastructure and `Cache Integration` tests to test the integration with the disk and keychain. Lastly, I used snapshot tests to validate the screens layout.

### Summary Table

![Testing Strategy](./Diagrams/testing_strategy.png)

### Methodology

I adopted the following naming convention for all tests: test_methodName_expectedOutputWhenGivenInput.

The tests were structured using the `Given-When-Then` template/structure.

To ensure there was no temporal coupling between tests and prevent artifacts from being left on the disk or in memory, I enabled test randomization for all targets (except for the `End-to-End` tests since they must run in order to create the user on the server, create the session after login and running all the tests that require authentication). Alternatively, I could have called the `signUp` and `login` requests before each request that requires authentication to avoid the temporal coupling between tests, but I choose to keep the order for now.

### Unit Tests

I based my testing pyramid's foundation on unit tests because they are the most reliable and cost-effective to write. Also, I can easily test each component in isolation by mocking collaborators without making any assumptions about the rest of the system.

### Integration Tests

Furthermore, I used end-to-end tests to check the connection with the backend APIs (my backend and Google Places API) to validate actual communication between the backends and the app. On top of that, I used cache integration tests to validate that the local storage functioned as intended given multiple instances.

#### End-to-End Tests

I used an `URLSession` with ephemeral configuration for both my own server and `Google Places API` to prevent caching successful requests as it's the default behaviour of `URLSession`. By disabling caching, I avoided the possibility of passing the tests while the network was unreachable because the previous cached request was returned. This approach mitigated the risk of unreliable behaviour.

#### Cache Integration Tests

When testing different systems in integration, it important to take into consideration the potential artifacts that can be created. To ensure a clean state before running each test, I deleted the store before and after each test using the `setUp` and `tearDown` methods. That's why I decided to inject the store URL in the `CoreDataLocalStore` to dynamically create a separate path when testing based on the test filename.

### Snapshots Tests

Initially, I wrote snapshots tests to verify the UI layout for each state by directly injecting the state in the viewModels. Afterwards, I used them to test-drive new screens as a feedback mechanism alongside with preview. It seemed like a better alternative because they are relatively fast to run, and I could check the UI for both light and dark modes simultaneously.

Nevertheless, I didn't test any logic with snapshot tests as all the logic was encapsulated within the already unit-tested viewModels.

## CI/CD

I used `GitHub Actions` to automate the CI/CD pipeline to ensure code changes are built and tested automatically. The pipeline runs every time commits are pushed to the main branch. It performs the following tasks:
1. Builds the app and runs all tests to ensure code changes do not break existing functionality.
2. Checks code quality with [SwiftLint](https://github.com/realm/SwiftLint) to ensure it adheres to the Swift coding style and conventions.

## Security

### API key for Google Places API

For security purposes, I stored the `API_KEY` for the `Google Places API` in a plist to prevent from being leaked in the source code by adding the file in the `.gitignore`. This ensures the file only exists locally on my device, thus preventing any possible leakage to an attacker who could make requests on my behalf for free.

### Store Tokens from FoodybiteServer in Keychain

I decided to store the tokens received on login from the server in the `Keychain` to guarantee the security and privacy of users since session tokens are considered sensitive information. If an attacker gains access to them, they can impersonate the real user and steal his data or make destructive actions.

`Keychain` is the default option of secure storage on iOS because it uses strong encryption to protect the data, making it difficult for other apps or users to access the stored information. Additionally, it can be erased remotely, further preventing unauthorized access.

### Password Hashing

I avoided sending passwords in clear text in the requests' body as they can be intercepted and read by a malicious attacker with access to the network traffic compromising the user's account and his personal information.

To prevent this scenario, I used `SHA512` to hash the passwords before sending to the backend. Even if an attacker intercept the hash, they will be unable to reverse the hash and find the password. On the other side, when the user logs in again, their entered password is hashed again, which results in the same hash as initially, allowing the server to grant access to their account.

## Metrics

| Environment | Files Count | Total lines of code | Average lines per file |
|------|------|------|------|
| Production | 206 | 8103 | 39 |
| Testing | 93 | 7733 | 83 |

> ❗️ Blank lines and comments are not considered. 

### Test lines of code per production lines of code

Below, You can see the entire evolution of the codebase. For the first part of the project, the testing curve stayed flat as I initially worked on the UI, testing out different ideas. Afterwards, I went through the process of building the modules in the order presented here.

The usage of `TDD` throughout the project is proved by the lack of flat segments on the testing curve. Each commit contained changes in both testing and production, and their spikes are directly correlated. It highlights how important it was for me to have automated tests before writing production code.

![Testing vs Production](./Diagrams/testing_vs_production.png)

### Count of files changed

My initial goal was to make commits as small as possible, very frequent, and with meaningful messages. Additionally, I strived for an average between `2 and 2.5` changed files per commit. Unfortunately, while polishing the last details of the project, I realised that I had used the concept of `place` instead of `restaurant` throughout the codebase. I had initially borrowed the naming from `Google Places`, and because they are similar and can be used interchangeably, as the set of places contains all restaurants.

However, I decided to replace the concepts everywhere in the project to maintain consistency with the initial purpose and to have meaningful domain models. Before the refactoring, I had an average of `2.35` files changed per commit. However, due to all the renaming that had to be done, it went up to `3.26`.

The following histogram represents the history of the number of files changed during the project. As you can see, `74% of all commits modified three or fewer files`. Moreover, most commits with more than ten files changed are due to renaming. Overall, the plot demonstrates my continuous effort of keeping high the granularity of the commits.

![Count of files changed](./Diagrams/count_of_files_changed.png)

> ❗️ It `only` includes changes to Swift files.

### Code coverage

Having high code coverage wasn't a goal during the project. Instead, my focus was to write quality tests. The code coverage emerged as a consequence of following `TDD` while building the modules. It's a useful metric to check what portions of the code are not executed by tests. However, it doesn't guarantee that all possible paths have been tested.

The `Persistence` module has only `47%` code coverage due to `CoreDataLocalStore` has generic methods which I tested using only the `ManagedUser` to validate its behaviour, so all the other managed models are not covered.

In the case of the `Location` module, I was unable to trigger delegate methods, that's why in order to test them I implemented my own delegate. (You can find more details here: [Get current location using TDD](#get-current-location-using-tdd))

So far, I haven't done any unit testing on views since they don't contain business logic. I tested them only through snapshot testing to ensure the correct layout. I had the option to test them using a third-party framework, called `ViewInspector`, but I wasn't comfortable to add the required setup in production to make it work. For this reason, I decided to test the views' logic using the preview or manually if necessary.

This is also valid for the views in the composition root that handles the navigation, that's the reason the coverage is only `40%`.

In conclusion, all the modules are completely tested, except the view logic from the `UI` and `Main` modules. However, I kept it to the bare minimum and can be easily tested using the preview. It was a trade-off I had to make, and I'm considering using the framework to write some acceptance tests in the future. For now, I'm satisfied with the current solution and confident that my testing strategy will ensure the stability of the application.

![Code coverage](./Diagrams/code_coverage.png)

## Credits

This beautiful design was made available by [Yagnesh P](https://www.behance.net/yagneshpipariya) for free here: [Foodybite Design](https://www.behance.net/gallery/81858385/Foobybite-Free-UI-Kit-for-Adobe-XD). You can also find him on dribbble.com: [Yagnesh P](https://dribbble.com/Yagneshp). Thank you, Yagnesh. 🙏

## References

1. [The iOS Lead Essential Program](https://iosacademy.essentialdeveloper.com/p/ios-lead-essentials/)
2. [Clean Architecture](https://www.goodreads.com/book/show/18043011-clean-architecture?ac=1&from_search=true&qid=cebbBLQz86&rank=1) by Robert C. Martin
3. [Clean Code: A Handbook of Agile Software Craftsmanship](https://www.goodreads.com/book/show/3735293-clean-code?from_search=true&from_srp=true&qid=0lfCKDxK4E&rank=1) by Robert C. Martin
4. [Dependency Injection Principles, Practices, and Patterns](https://www.goodreads.com/book/show/44416307-dependency-injection-principles-practices-and-patterns?ref=nav_sb_ss_1_27) by Mark Seemann and Steven van Deursen
5. [Domain-Driven Design: Tackling Complexity in the Heart of Software](https://www.goodreads.com/book/show/179133.Domain_Driven_Design?ref=nav_sb_noss_l_16)
6. [Design It! : Pragmatic Programmers: From Programmer to Software Architect](https://www.goodreads.com/book/show/31670678-design-it?from_search=true&from_srp=true&qid=Nm98t342VP&rank=6) by Michael Keeling
