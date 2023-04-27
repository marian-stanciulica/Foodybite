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