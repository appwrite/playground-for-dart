# Playground for Dart

Simple examples that help you get started with Appwrite + Dart (=❤️)

This is Appwrite server side integration with Dart. For Flutter integration please look at our [Flutter playground](https://github.com/appwrite/playground-for-flutter) and [Flutter SDK](https://github.com/appwrite/sdk-for-flutter)

### Work in progress

Appwrite playground is a simple way to explore the Appwrite API and Appwrite Dart SDK. Use the source code of this page to learn how to use different Appwrite Dart SDK features.

## Get Started
This playground doesn't include any dart best practices, but rather intended to show some of the most simple examples and use cases of using the Appwrite API in your dart application.

## System Requirements
* A Linux/Windows/Mac system with Dart 3 installed
* You have readily available Appwrite running instance (localhost in most cases).
* Create a project in Appwrite instance using console
* Generate a secret API key in the Appwrite instance using console

### Installation
1. Clone this repository
2. cd into the repository
3. Install the dependencies with `dart pub get`
4. Copy the project ID, endpoint and API key from the Appwrite Console and export them:
    ```bash
    export APPWRITE_ENDPOINT="http://localhost/v1"
    export APPWRITE_PROJECT_ID="<YOUR_PROJECT_ID>"
    export APPWRITE_API_KEY="<YOUR_API_KEY>"
    ```
    Alternatively, replace the fallback values at the top of `main.dart` directly.
5. Execute the command `dart run main.dart`
6. You will see the JSON response in the console

The playground creates every resource with a unique ID and deletes it again at the end, so it is safe to run repeatedly.

### API Covered in Playground

- Databases (deprecated since Appwrite 1.8, kept for existing projects)
    * Create Database
    * List Databases
    * Get Database
    * Update Database
    * Delete Database
    * Create Collection
    * List Collections
    * Get Collection
    * Update Collection
    * Delete Collection
    * List Attributes
    * List Indexes
    * Create Document
    * List Documents
    * Get Document
    * Update Document
    * Delete Document

- TablesDB
    * Create Database
    * List Databases
    * Get Database
    * Update Database
    * Delete Database
    * Create Table
    * List Tables
    * Get Table
    * Update Table
    * Delete Table
    * Create Columns
    * List Columns
    * Get Column
    * Delete Column
    * Create Index
    * List Indexes
    * Delete Index
    * Create Row
    * List Rows
    * Get Row
    * Update Row
    * Delete Row

- Transactions
    * Create Transaction
    * Get Transaction
    * List Transactions
    * Stage Create Row
    * Stage Update Row
    * Create Operations (batch staging)
    * Commit Transaction
    * Rollback Transaction
    * Delete Transaction

- Storage
    * Create Bucket
    * List Buckets
    * Get Bucket
    * Update Bucket
    * Delete Bucket
    * Upload File
    * List Files
    * Get File
    * Download File
    * Preview File
    * Update File
    * Delete File

- Users
    * Create User
    * List Users
    * Get User
    * Update Name
    * Get Preferences
    * Update Preferences
    * Delete User

- Teams
    * Create Team
    * List Teams
    * Get Team
    * Delete Team
    * Create Membership
    * List Memberships
    * Delete Membership

- Functions
    * Create Function
    * List Functions
    * Get Function
    * Update Function
    * Create Variable
    * List Variables
    * Get Variable
    * Update Variable
    * Delete Variable
    * List Deployments
    * List Executions
    * Delete Function

Uploading a deployment and executing a function are not covered, because this repository does not ship a deployment package to upload.

## Contributing

All code contributions - including those of people having commit access - must go through a pull request and approved by a core developer before being merged. This is to ensure proper review of all the code.

We truly ❤️ pull requests! If you wish to help, you can learn more about how you can contribute to this project in the [contribution guide](https://github.com/appwrite/appwrite/blob/master/CONTRIBUTING.md).

## Security

For security issues, kindly email us [security@appwrite.io](mailto:security@appwrite.io) instead of posting a public issue in GitHub.

## Follow Us

Join our growing community around the world! Follow us on [Twitter](https://twitter.com/appwrite), [Facebook Page](https://www.facebook.com/appwrite.io), [Facebook Group](https://www.facebook.com/groups/appwrite.developers/) or join our [Discord Server](https://appwrite.io/discord) for more help, ideas and discussions.
