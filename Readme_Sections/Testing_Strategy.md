## Testing Strategy

Throughout the entire project, I've used `TDD` as the development process (excluding the UI layer) by following the feedback loop.

Having used `TDD` for over a year, I really enjoy how it allows me to break down tasks and solve one problem at a time. Also, I find it interesting how the design evolves naturally when using `TDD`. Additionally, it has helped me understand better what I was trying to build before writing code while increasing my confidence in the system's correctness.

The foundation for my testing strategy was unit tests for the system internals (without hitting external systems like the network or the disk). In addition, I wrote `End-to-End` tests to test the integration with the network infrastructure and `Cache Integration` tests to test the integration with the disk and keychain. Lastly, I used snapshot tests to validate the screens layout.

### Summary Table

![Testing Strategy](./testing_strategy.png)

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