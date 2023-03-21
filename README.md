# Foodybite

## Motivation

## Architecture

![Top Level Modules](./Diagrams/Top_Level_View_Modules.svg)

Layers:
- [Shared API](#shared-api)
- [Networking](#networking)
- [Places](#places)
- [Persistence](#persistence)
- [Location](#location)
- [Domain](#domain)
- [Presentation](#presentation)
- [UI](#ui)

### Shared API

![Shared API](./Diagrams/Shared_API.svg)

### Networking
The following diagram represents the networking layer talking with my backend app. For a better understanding, I will explain each major section of the diagram and decisions made during testing (all components were tested using TDD):
1. [Refresh Token Strategy](#1-refresh-token-strategy)
2. [Network Request Flow](#2-network-request-flow)
3. [Endpoint Creation](#3-endpoint-creation)
4. [Mock Network Requests](#4-mock-network-requests)
5. [Testing **Data** to **Decodable** Mapping](#5-testing-data-to-decodable-mapping)

> ❗ I excluded the legend from the diagram to have more space. You can find it [here](./Diagrams/Legend.svg).

![Networking Diagram](./Diagrams/Networking.svg)

| Component | Responsibility |
|------|------|
| KeychainTokenStore | Performs read/write operations from/to Keychain on AuthToken |
| RefreshTokenService | Fetches new **AuthToken** from server and stores it in **TokenStore** |
| RefreshTokenEndpoint | Defines the path, method and body for the refresh token endpoint |
| AuthToken | Struct containing accessToken and refreshToken |
| AuthenticatedURLSessionHTTPClient | Decorator over **HTTPClient** that adds authentication capabilities to the client |
| RemoteStore | Validates the response from **HTTPClient** and parses the data |
| APIService | Creates the endpoints and sends them to the **ResourceLoader** or **ResourceSender** |

#### 1. Refresh Token Strategy

![Refresh Token State Machine](./Diagrams/Refresh_Token_State_Machine.svg)

#### 2. Network Request Flow

This flow is composed by 3 classes: 
- **APIService**, which implements domain protocols, creates **URLRequest** objects from endpoints and sends them to the remote store.
- **RemoteStore**, which implements **ResourceLoader** and **ResourceSender**, validates the status code returned by the client and parses received data.
- **AuthenticatedURLSessionHTTPClient**, which implements **HTTPClient**, signs each request using the access token fetched using an **TokenRefresher** collaborator (You can find more details about refresh token strategy [here](#1-refresh-token-strategy)). In the **Composition Root** this class is used only for requests that require authentication, otherwise an instance of **URLSessionHTTPClient** from the **SharedAPI** module is used.

![AuthenticatedURLSessionHTTPClient](./Diagrams/AuthenticatedURLSessionHTTPClient.svg)

#### 3. Endpoint Creation

Initially, I created a single enum with individual cases for each request which conformed to the **Endpoint** protocol. It was a convenient choice because all requests available were grouped in a single file, but as I was adding more requests I realized that each time the same file is modified, thus breaking the **Open/Closed Principle** which states that the system should be open for extension, but closed for modification.

I immediately pivoted and extracted the related cases in separate enums with related cases, like it is the case for **AccountEndpoint** which has cases for **POST** and **DELETE**. 

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

Otherwise, if a case is not related any other case then I extracted it in a struct with the body as the instance property.

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
Currently, when the need to add another endpoint arises, I can create another struct which conforms to **Endpoint** or edit a file containing related endpoints to the one I want to add (this case still violates the principle, but considering the relatedness of the endpoints I think it's a good trade-off for now).

#### 4. Mock Network Requests

I prefer not to hit the network while testing the **URLSessionHTTPClient**. In my experience, there are 3 ways to mock a network request which uses **URLSession**:

1. By creating a spy/stub class for **URLSession**, overriding the following method to return stubbed data or capturing the parameters.

```swift
func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
```

> 🚩 There are a lot more methods in the 𝐔𝐑𝐋𝐒𝐞𝐬𝐬𝐢𝐨𝐧 class that we don't control and by subclassing we assume the behaviour of the overridden method is not depending on other methods.

2. By creating a protocol with only the method we are interested in mocking and making **URLSession** conform to it. Furthermore, we can implement our spy/stub using the protocol.

```swift
public protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
```

> 🚩 The need to create the protocol in production for the sole purpose of testing because it's not an abstraction meant to be used by other clients.

3. By subclassing **URLProtocol** and overriding a couple of methods to intercept the requests. Also, the stub should be registered by calling **URLProtocol.registerClass(URLProtocolStub.self)** to be used by the **URL Loading System**.

✅ For this project, I opted out to use the third option as it's the most reliable and it doesn't require to create additional files only for testing, thus cluterring the production side.

#### 5. Testing **Data** to **Decodable** Mapping

For testing the mapping from **Data** to **Decodable** I chose to test it directly in the **RemoteStore**, hiding the knowledge of a collaborator (in this case **CodableDataParser**). While I could do this using a stubbed collaborator (e.g. a protocol **DataParser**), I prefered to test in integration the mapping, resulting in less complexity and less coupling of tests with the production code.

### Places

![Places](./Diagrams/Places.svg)

### Persistence

### Location

The following diagram presents the **Location** module and how it interacts with the **CoreLocation**.

In this module, I chose to switch from the classic delegation pattern of getting the current location to the **async/await** approach using a continuation (You can find more details about it here: [From delegation to async/await](#from-delegation-to-async/await)).

Another interesting topic related to this module is how I was able to use TDD to get the current location using **CLLocationManager** and **CLLocationManagerDelegate**. (More details here: [Get current location using TDD](#get-current-location-using-tdd))

![Location](./Diagrams/Location.svg)

| Component | Responsibility |
|------|------|
| LocationProvider | Fetches user's current location |
| DistanceSolver | Computes distance between two locations |

#### From delegation to async/await

#### Get current location using TDD

### Domain

### Presentation

### UI

![Screen Hierarchy](./Diagrams/Screen_Hierarchy.svg)

## Testing Pyramid

1. Unit testing
2. Snapshots Testing
3. End-to-End Testing
