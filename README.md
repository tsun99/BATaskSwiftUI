# BATaskSwiftUI

This SwiftUI application displays user names, post titles, and posts. The data is stored and initially retrieved from a Firestore database, populated using a combination of user and post APIs. You can use your own Firestore database by setting up a new Firebase app and replacing the `GoogleService-Info.plist` file.

## Features

- Display user names, post titles, and posts in a list.
- Pull-to-refresh functionality to update the database with data from user and post APIs.

## Installation

1. Clone this repository to your local machine.
2. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/).
3. Follow the setup instructions to integrate Firebase into your Xcode project:
   - Add your iOS app to the Firebase project.
   - Download the `GoogleService-Info.plist` file and replace the existing one in the Xcode project.

## Usage

1. Launch the app on your iOS Simulator or device.
2. The app will display a list of user names, post titles, and posts fetched from Firestore. (If running the app for the first time, with your own set-up Firebase app, the list will be empty until pulling down to refresh.)
3. To update the database with new data, pull down on the list to trigger the pull-to-refresh functionality.
4. The app will fetch new data from user and post APIs and update the Firestore collections accordingly.
