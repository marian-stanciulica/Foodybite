[![CI-iOS](https://github.com/Marian25/Foodybite/actions/workflows/ios.yml/badge.svg)](https://github.com/Marian25/Foodybite/actions/workflows/ios.yml)

# Foodybite

💡 My vision for this project is centered around a simple yet powerful way to create a user-friendly app that helps you find the best restaurant near you based on location, radius, and number of stars. Additionally, users can see details, like opening hours, address, reviews, or photos for each restaurant found and give a review. The app allows users to search directly for a restaurant and enables them to give a review right away.

1. [Motivation](#motivation)
2. [Installation Guide](#installation-guide)
3. [Demo](#demo)
4. [Tools](#tools)
5. [Frameworks](#frameworks)
6. [Concepts](#concepts)
7. [Architecture](./Readme_Sections/Architecture.md#architecture)
    1. [Overview](./Readme_Sections/Architecture.md#overview)
    2. [Domain](./Readme_Sections/Architecture.md#domain)
        1. [User Session Feature](./Readme_Sections/Architecture.md#1-user-session-feature)
        2. [Update/Delete Account Feature](./Readme_Sections/Architecture.md#2-updatedelete-account-feature)
        3. [Store/Retrieve User Preferences Feature](./Readme_Sections/Architecture.md#3-storeretrieve-user-preferences-feature)
        4. [Nearby Restaurants Feature](./Readme_Sections/Architecture.md#4-nearby-restaurants-feature)
        5. [Fetch Restaurant Photo Feature](./Readme_Sections/Architecture.md#5-fetch-restaurant-photo-feature)
        6. [Restaurant Details Feature](./Readme_Sections/Architecture.md#6-restaurant-details-feature)
        7. [Autocomplete Restaurants Feature](./Readme_Sections/Architecture.md#7-autocomplete-restaurants-feature)
        8. [Add Review Feature](./Readme_Sections/Architecture.md#8-add-review-feature)
        9. [Get Reviews Feature](./Readme_Sections/Architecture.md#9-get-reviews-feature)
        10. [Location Feature](./Readme_Sections/Architecture.md#10-location-feature)
    3. [Networking](./Readme_Sections/Architecture.md#networking)
        1. [Refresh Token Strategy](./Readme_Sections/Architecture.md#1-refresh-token-strategy)
        2. [Network Request Flow](./Readme_Sections/Architecture.md#2-network-request-flow)
        3. [Endpoint Creation](./Readme_Sections/Architecture.md#3-endpoint-creation)
        4. [Testing `Data` to `Decodable` Mapping](./Readme_Sections/Architecture.md#4-testing-data-to-decodable-mapping)
        5. [Parsing JSON Response](./Readme_Sections/Architecture.md#5-parsing-json-response)
    4. [Places](./Readme_Sections/Architecture.md#places)
    5. [API Infra](./Readme_Sections/Architecture.md#api-infra)
        1. [Mock Network Requests](./Readme_Sections/Architecture.md#mock-network-requests)
    6. [Persistence](./Readme_Sections/Architecture.md#persistence)
        1. [Cache Domain Models](./Readme_Sections/Architecture.md#cache-domain-models)
        2. [Infrastructure](./Readme_Sections/Architecture.md#infrastructure)
        3. [Store User Preferences](./Readme_Sections/Architecture.md#store-user-preferences)
    7. [Location](./Readme_Sections/Architecture.md#location)
        1. [From delegation to async/await](./Readme_Sections/Architecture.md#from-delegation-to-asyncawait)
        2. [Get current location using TDD](./Readme_Sections/Architecture.md#get-current-location-using-tdd)
    8. [Presentation](./Readme_Sections/Architecture.md#presentation)
    9. [UI](./Readme_Sections/Architecture.md#ui)
    10. [Main](./Readme_Sections/Architecture.md#main)
        1. [Adding caching by intercepting network requests](./Readme_Sections/Architecture.md#adding-caching-by-intercepting-network-requests) (`Decorator Pattern`)
        2. [Adding fallback strategies when network requests fail](./Readme_Sections/Architecture.md#adding-fallback-strategies-when-network-requests-fail) (`Composite Pattern`)
        3. [Handling navigation](./Readme_Sections/Architecture.md#handling-navigation) (flat and hierarchical navigation)
8. [Testing Strategy](https://github.com/marian-stanciulica/Foodybite/blob/main/Readme_Sections/Testing_Strategy.md#testing-strategy)
    1. [Summary Table](https://github.com/marian-stanciulica/Foodybite/blob/main/Readme_Sections/Testing_Strategy.md#summary-table)
    2. [Methodology](https://github.com/marian-stanciulica/Foodybite/blob/main/Readme_Sections/Testing_Strategy.md#methodology)
    3. [Unit Tests](https://github.com/marian-stanciulica/Foodybite/blob/main/Readme_Sections/Testing_Strategy.md#unit-tests)
    4. [Integration Tests](https://github.com/marian-stanciulica/Foodybite/blob/main/Readme_Sections/Testing_Strategy.md#integration-tests)
        1. [End-to-End Tests](https://github.com/marian-stanciulica/Foodybite/blob/main/Readme_Sections/Testing_Strategy.md#end-to-end-tests)
        2. [Cache Integration Tests](https://github.com/marian-stanciulica/Foodybite/blob/main/Readme_Sections/Testing_Strategy.md#cache-integration-tests)
    5. [Snapshot Tests](https://github.com/marian-stanciulica/Foodybite/blob/main/Readme_Sections/Testing_Strategy.md#snapshot-tests)
9. [CI/CD](#cicd)
10. [Security](#security)
    1. [API key for Google Places API](#api-key-for-google-places-api)
    2. [Store Tokens from FoodybiteServer in Keychain](#store-tokens-from-foodybiteserver-in-keychain)
    3. [Password Hashing](#password-hashing)
11. [Metrics](#metrics)
    1. [Test lines of code per production lines of code](#test-lines-of-code-per-production-lines-of-code)
    2. [Count of files changed](#count-of-files-changed)
    3. [Code coverage](#code-coverage)
12. [Credits](#credits)
13. [References](#references)

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

### Sign Up

https://user-images.githubusercontent.com/11156132/234677287-425734c9-0d49-4910-a219-c3fdefab51f8.mp4

### Home

https://user-images.githubusercontent.com/11156132/234677401-d642c47d-c00f-4513-b613-4146e1982c2d.mp4

### Home Search

https://user-images.githubusercontent.com/11156132/234677436-760e4c0e-2161-46b2-ab34-9d59bd106a6f.mp4

### Post Review

https://user-images.githubusercontent.com/11156132/234779276-a0403c00-a69d-4085-961d-ce5f63091fb5.mp4

### Profile

https://user-images.githubusercontent.com/11156132/234677956-9803775e-d151-4dd9-8e20-e0d0071b5772.mp4

## Tools
- ✅ Xcode 14.2
- ✅ Swift 5.7

## Frameworks
- ✅ SwiftUI
- ✅ Combine
- ✅ CoreData
- ✅ CoreLocation

## Concepts
- ✅ MVVM, Clean Architecture
- ✅ Modular Design
- ✅ SOLID Principles
- ✅ TDD, Unit Testing, Integration Testing, Snapshot Testing
- ✅ Composite, Decorator Patterns
- ✅ Domain-Driven Design

## CI/CD

I used `GitHub Actions` to automate the CI/CD pipeline to ensure code changes are built and tested automatically. The pipeline runs every time commits are pushed to the main branch. It performs the following tasks:
1. Checks code quality with [SwiftLint](https://github.com/realm/SwiftLint) to ensure it adheres to the Swift coding style and conventions.
2. Builds the app and runs all tests to ensure code changes do not break existing functionality.

## Security

### API key for Google Places API

For security purposes, I stored the `API_KEY` for the `Google Places API` in a plist to prevent from being leaked in the source code by adding the file in the `.gitignore`. This ensures the file only exists locally on my device, thus preventing any possible leakage to an attacker who could make requests on my behalf for free.

### Store Tokens from FoodybiteServer in Keychain

I decided to store the tokens received on login from the server in the `Keychain` to guarantee the security and privacy of users since session tokens are considered sensitive information. If an attacker gains access to them, they can impersonate the real user and steal his data or make destructive actions.

`Keychain` is the default option of secure storage on iOS because it uses strong encryption to protect the data, making it difficult for other apps or users to access the stored information. Additionally, it can be erased remotely, further preventing unauthorized access.

### Password Hashing

I avoided sending passwords in clear text in the requests' body as they can be intercepted and read by a malicious attacker with access to the network traffic compromising the user's account and his personal information.

To prevent this scenario, I used `SHA512` to hash the passwords before sending to the backend. Even if an attacker intercept the hash, they will be unable to reverse the hash and find the password. On the other side, when the user logs in again, their entered password is hashed again, which results in the same hash as initially, allowing the server to grant access to their account.

## Credits

This beautiful design was made available by [Yagnesh P](https://www.behance.net/yagneshpipariya) for free here: [Foodybite Design](https://www.behance.net/gallery/81858385/Foobybite-Free-UI-Kit-for-Adobe-XD). You can also find him on dribbble.com: [Yagnesh P](https://dribbble.com/Yagneshp). Thank you, Yagnesh. 🙏

## References

1. [The iOS Lead Essential Program](https://iosacademy.essentialdeveloper.com/p/ios-lead-essentials/)
2. [Clean Architecture](https://www.goodreads.com/book/show/18043011-clean-architecture?ac=1&from_search=true&qid=cebbBLQz86&rank=1) by Robert C. Martin
3. [Clean Code: A Handbook of Agile Software Craftsmanship](https://www.goodreads.com/book/show/3735293-clean-code?from_search=true&from_srp=true&qid=0lfCKDxK4E&rank=1) by Robert C. Martin
4. [Dependency Injection Principles, Practices, and Patterns](https://www.goodreads.com/book/show/44416307-dependency-injection-principles-practices-and-patterns?ref=nav_sb_ss_1_27) by Mark Seemann and Steven van Deursen
5. [Domain-Driven Design: Tackling Complexity in the Heart of Software](https://www.goodreads.com/book/show/179133.Domain_Driven_Design?ref=nav_sb_noss_l_16)
6. [Design It! : Pragmatic Programmers: From Programmer to Software Architect](https://www.goodreads.com/book/show/31670678-design-it?from_search=true&from_srp=true&qid=Nm98t342VP&rank=6) by Michael Keeling
