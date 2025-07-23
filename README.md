# 🎬 iOS Movie Listing App

An iOS movie listing app built as part of a technical assessment for Momentum Solutions. The app displays popular and top-rated movies using data from [TMDB](https://www.themoviedb.org/) API.

## Features

- Display **Top 2025 Movies** and **Popular Movies** in horizontal lists.
- Tap on a movie to view detailed information.
- Mark/unmark movies as **Favorite**.
- View all **favorite movies** in a dedicated screen.
- Offline support for movie lists using caching.
- Smooth animations using **Lottie**.

## Technologies & Architecture

- **Language:** Swift  
- **Architecture:** MVVM  
- **Dependency Injection:** Swinject  
- **Networking:** Alamofire  
- **Reactive Programming:** Combine  
- **Image Caching:** SDWebImage  
- **Persistence:**
  - FileManager for movie list caching
  - UserDefaults for storing favorite movies  
- **Unit Testing:** XCTest with Mocked Network Layer

## Installation

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/movies-task.git
2. Navigate to the project directory:
3. Open the project in Xcode:
4. Open MoviesTask.xcodeproj using Xcode.
5. Install dependencies:
   This project uses Swift Package Manager (SPM).
   Xcode will automatically resolve dependencies on build.
6. Run the app:
   Select a simulator or your device.
   Press Cmd + R  button to build and run.
   Run the tests (optional):
   Use Cmd + U to run the unit tests



