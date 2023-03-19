# Foodybite

# Networking

## Mock Network Requests
While testing the 'URLSessionHTTPClient' I prefer not to hit the network for each test. In my experience, there are 3 ways to mock a network request which uses URLSession:

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
