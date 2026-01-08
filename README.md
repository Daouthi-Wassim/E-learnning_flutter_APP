# E-School Flutter App

A comprehensive e-learning mobile application built with Flutter and Firebase. This app allows users to browse courses/books, manage their profiles, and save their favorite learning materials.

## 📱 Features

- **User Authentication**: Secure login and signup functionality using Firebase Auth.
- **Book/Course Browsing**: View details of available books and courses.
- **Favorites Management**: Add books to your "My Books" collection for easy access.
- **Profile Management**: View and edit user profile details.
- **Modern UI**: Clean interface with animations (using Lottie) and shimmer loading effects.

## 🛠️ Tech Stack

- **Frontend**: Flutter
- **Backend/Services**: Firebase (Authentication, Cloud Firestore)
- **State Management**: (Implicit/StatefulWidgets - *Update if specific state management is used*)
- **Key Packages**:
  - `firebase_auth`, `cloud_firestore`: For backend services.
  - `shared_preferences`: Local data persistence.
  - `http`: For making API calls (if applicable).
  - `cached_network_image`: Efficient image loading.
  - `lottie`: detailed animations.
  - `shimmer`: Loading skeletons.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed (Version ^3.9.2 as per pubspec)
- Dart SDK installed
- A Firebase project configured.

### Installation

1. **Clone the repository**
2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**
   - Ensure your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are placed in their respective directories (`android/app` and `ios/Runner`).
   - Or use `flutterfire configure` if you have the CLI set up.

4. **Run the App**
   ```bash
   flutter run
   ```

## 📂 Project Structure

- `lib/view/pages`: Contains all the screen UI code (Login, Home, Details, etc.).
- `lib/view/widgets`: Reusable UI components.
- `lib/services`: Business logic and API/Firebase handling.
- `lib/models`: Data models.
- `lib/const`: Constants and static data.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
