# Foodybite

# Networking
![Networking Diagram](./Diagrams/Networking.svg)

## Mock Network Requests
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

## Open/Closed Principle

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


























