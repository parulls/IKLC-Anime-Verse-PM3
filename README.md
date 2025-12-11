<div align="center">

# 🎬 AnimeVerse
**Your Ultimate Gateway to the Anime World**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Jikan API](https://img.shields.io/badge/API-Jikan_v4-bc2f68?style=for-the-badge)](https://jikan.moe/)

</div>

## 👤 Student Identity

| Field | Detail |
| :--- | :--- |
| **Name** | Parulian Dwi Reslia Simbolon |
| **NIM** | 231401032 |
| **Lab** | Mobile Programming 3 |

## 📱 Project Overview

**AnimeVerse** is a modern, feature-rich mobile application crafted for anime enthusiasts who want a seamless way to discover, track, and organize their favorite shows.

Built with **Flutter** and powered by **Firebase**, the app integrates with the **Jikan API (Unofficial MyAnimeList API)** to provide real-time data. It offers a robust ecosystem featuring secure authentication, cloud-synced favorites, and a responsive UI designed with Material 3 principles.

### 🎯 Key Objectives
- **Discover:** Browse trending, top-rated, and upcoming anime.
- **Search:** Instant search functionality to find specific titles.
- **Organize:** Manage a personal list of favorites synced across devices.
- **Experience:** Enjoy a smooth, ad-free experience with dark mode support.

## ✨ Key Features

### 🔐 Secure Authentication
- **Sign Up/In:** Robust email & password validation.
- **Google OAuth:** One-click login using Google accounts.
- **Password Recovery:** Easy reset via email.
- **Session Management:** Persistent login state.

### 🏠 Dynamic Home & Discovery
- **Top Anime Lists:** View trending and popular shows.
- **Smart Search:** Real-time search capability.
- **Genre Filtering:** Filter by Action, Adventure, Drama, etc.
- **Infinite Scrolling:** Seamless pagination for browsing.
- **Refresh Control:** Pull-to-refresh to update data.

### ❤️ Cloud Favorites
- **Real-time Sync:** Favorites are stored in Firebase Realtime Database.
- **Management:** Add or remove favorites instantly.
- **Search Favorites:** Quickly find shows within your personal list.
- **Cross-Device:** Access your list from any device.

### 📄 Comprehensive Details
- **Deep Dive:** Synopsis, score, episode count, status, and genres.
- **Visuals:** High-resolution cover art and posters.
- **Interactive UI:** Smooth sliver scrolling and responsive layouts.

### 👤 User Profile
- **Account Info:** View profile details and member badges.
- **Security:** Change password and manage account settings.
- **App Info:** Version details and credits.


## 🛠️ Tech Stack

### Frontend & Architecture
- **Framework:** Flutter (Material 3)
- **Language:** Dart
- **Architecture:** MVVM (Model-View-ViewModel)
- **State Management:** Provider
- **Navigation:** GoRouter (Type-safe routing)

### Backend & Services
- **Authentication:** Firebase Authentication
- **Database:** Firebase Realtime Database
- **Storage:** Firebase Cloud Storage
- **API:** Jikan REST API v4

### Libraries & Tools
- `cached_network_image` - Efficient image caching
- `flutter_svg` - Vector asset support
- `image_picker` - Profile picture selection
- `shared_preferences` - Local settings persistence


## 📸 App Screenshots

| Splash Screen | Sign In | Sign Up |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/ccb59520-cebc-4513-aee8-4cbf585b133e" height="400" /> | <img src="https://github.com/user-attachments/assets/e8c1fb50-f84a-4ebc-a2d5-5e279da970a5" height="400" /> | <img src="https://github.com/user-attachments/assets/4e2009d1-4b3e-4cc9-8a19-d0a0d2a104ac" height="400" /> |

| Home Screen | Detail Screen |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/9f273306-c893-4162-a7b7-47b3cefa2022" height="400" /> | <img src="https://github.com/user-attachments/assets/988b666e-9da2-4ddc-92f3-b9950d6679de" height="400" /> |

| Favorites | Profile |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/7e09bd13-bb0a-4435-987a-187e31a247f0" height="400" /> | <img src="https://github.com/user-attachments/assets/5ae32525-51d4-418f-ba9a-7473b201c7db" height="400" /> |



## 💻 Installation & Setup

Follow these steps to run the project locally.

### Prerequisites
- Flutter SDK (v3.0+)
- Dart SDK
- Android Studio / VS Code
- Git

### 1. Clone the Repository
```bash
git clone "https://github.com/parulls/IKLC-Anime-Verse-PM3.git"
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Firebase Configuration

1. Create a project in the [[Firebase Console](https://console.firebase.google.com)].
2. Enable Authentication (Email/Password & Google).
3. Create a Realtime Database and set rules to allow authenticated users.
4. Android: Download google-services.json and place it in android/app/.
5. iOS: Download GoogleService-Info.plist and place it in ios/Runner/.

#### 4. Run Project

```bash
# Check connected devices
flutter devices

# Run on Android
flutter run
```

## 📁 Project Structure

### Key Files Description
- `lib/models/anime.dart`: Anime data model
- `lib/provider/app_state_provider.dart`: State management for anime, favorites, search
- `lib/screens/`: Main screens (home, detail, favorites, profile, signin, signup)
- `lib/widgets/`: UI components (anime card, favorite card, scaffold, gradient background)
- `assets/images/`: Anime images and icons
- `assets/fonts/`: Urbanist font family

## 📦 Dependency & Package

### Core Dependencies
```yaml
provider: ^6.0.0              # State management
go_router: ^10.0.0            # Navigation
firebase_core: ^2.x           # Firebase
firebase_auth: ^4.x           # Auth
firebase_database: ^10.x      # Database
firebase_storage: ^11.x       # Storage
dio: ^5.x                     # HTTP
cached_network_image: ^3.x    # Image caching
flutter_svg: ^2.x             # SVG support
image_picker: ^1.x            # Image picker
```

## 🚀 Link Demo & Repository

### Repository
**GitHub**: [LINK](https://github.com/parulls/IKLC-Anime-Verse-PM3.git)

### Link Demo
**Video**: [LINK](https://drive.google.com/drive/folders/1U1YFopqOjGMwS3xEgTmThw6aJ5Oe7NpA?usp=sharing)

<div align="center"> <small>Built with ❤️ using Flutter for Mobile Programming Task 2025</small> </div>
