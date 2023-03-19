# Foodybite

## Motivation

## Architecture

Layers:
    - Shared API
    - [Networking](#networking)
    - Places
    - Persistence
    - Location
    - Domain
    - Presentation
    - UI

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
- **APIService** which implements domain protocols and creates **URLRequest** objects from endpoints and sends them to the remote store.
- **RemoteStore** which implements **ResourceLoader** and **ResourceSender**, validates the status code returned by the client and parses expected data.
- **AuthenticatedURLSessionHTTPClient** which implements **HTTPClient** and sign each request using the access token fetch using an **TokenRefresher** collaborator (You can find more details about refresh token strategy [here](#1-refresh-token-strategy)). In the **Composition Root** this class is used only for requests that requires authentication, otherwise an instance of **URLSessionHTTPClient** from the **SharedAPI** module is used.

![AuthenticatedURLSessionHTTPClient](./Diagrams/AuthenticatedURLSessionHTTPClient.svg)

#### 3. Endpoint Creation

##### Open/Closed Principle

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
While testing the **URLSessionHTTPClient** I prefer not to hit the network for each test. In my experience, there are 3 ways to mock a network request which uses **URLSession**:

1. By creating a spy class for **URLSession** and override the following method to return stubbed data not to hit the network and capture the parameters.

```swift
func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
```

> 🚩 There are a lot more methods in the 𝐔𝐑𝐋𝐒𝐞𝐬𝐬𝐢𝐨𝐧 class that we don't control and by subclassing we assume the behaviour of the overriden method is not depending on other methods.

2. By creating a protocol with only the method we are interested in mocking and making 𝐔𝐑𝐋𝐒𝐞𝐬𝐬𝐢𝐨𝐧 conform to it. Now, we can implement our spies using the protocols.

```swift
public protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
```

> 🚩 The need to create the protocol in production for the sole purpose of testing because it's not an abstraction meant to be used by other clients.

3. By subclassing **URLProtocol** and overriding a couple of methods to intercept the requests. Also, the stub should be registered by calling **URLProtocol.registerClass(URLProtocolStub.self)** to be used by the **URL Loading System**.

Currently, I went with the second option as I'm still unable to make it work by subclassing URLProtocol and async/await.

#### 5. Testing **Data** to **Decodable** Mapping

For testing the mapping from **Data** to **Decodable** I chose to test it directly in the **RemoteStore**, hiding the knowledge of a collaborator (in this case **CodableDataParser**). While I could do this using a stubbed collaborator (e.g. a protocol **DataParser**), I prefered to test in integration the mapping, resulting in less complexity and less coupling of tests with the production code.