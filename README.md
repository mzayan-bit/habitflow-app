HabitFlow

Build better habits, maintain streaks, and find your flow.

HabitFlow is a modern, offline-first habit tracker built with Flutter. It combines local persistence for speed with Cloud Firestore for backup, allowing users to track habits, visualize progress with heatmaps, and stay focused with a built-in timer.


✨ Key Features
📊 Advanced Analytics: Visualize your consistency with GitHub-style contribution Heatmaps, Category Pie Charts, and overall completion rates.

🔥 Streak Tracking: Gamify your progress with current and best streak counters for every habit.

💾 Offline-First Architecture: Built with Hive for instant local data access, syncing to Firebase Firestore when online.

⏱️ Focus Mode: Integrated Pomodoro Timer to help you dedicate time to your habits without distractions.

🔔 Smart Reminders: Local push notifications scheduled for specific days of the week.

🎨 Customization:

Pick from thousands of icons (Material & FontAwesome).

Color-code habits for better organization.

Sleek Dark Mode UI.

🔐 Flexible Auth: Sign in with Email/Password, Google, Twitter, or start as a Guest and link your account later.

👥 Community: (Beta) A social feed to see how others are progressing.


🛠️ Tech Stack
Framework: Flutter (Dart)

State Management: Flutter Riverpod (2.x)

Backend & Auth: Firebase Auth, Cloud Firestore

Local Database: Hive (NoSQL)

Charts: fl_chart & flutter_heatmap_calendar

Icons: flutter_iconpicker

Notifications: flutter_local_notifications

Getting Started
1. Prerequisites
Flutter SDK installed (>=3.4.1)

VS Code or Android Studio

A Firebase Project

2. Installation
    1.Clone the repo:

    git clone https://github.com/mzayan-bit/habitflow-app.git
    cd habitflow-app

    2.Install dependencies:

    flutter pub get

    3.Firebase Setup:

    Create a project in the Firebase Console.

    Enable Authentication (Email, Google, Twitter, Anonymous).

    Enable Cloud Firestore.

    Configure your app using FlutterFire CLI:

    flutterfire configure

    4.Run the app:

    flutter run


    📂 Project Structure
    The project follows a Feature-First architecture for scalability:
'''
    lib/
    ├── main.dart                  # Entry point & Theme config
    ├── src/
    │   ├── features/
    │   │   ├── auth/              # Login, Sign up, Auth Repository
    │   │   ├── habits/            # Habit CRUD, Hive Logic, Screens
    │   │   ├── analytics/         # Stats & Charts
    │   │   ├── focus/             # Focus Timer Logic
    │   │   ├── community/         # Social Feed
    │   │   └── settings/          # User Settings & Profile
    │   └── shared/
    │       ├── services/          # Notification Service
    │       └── widgets/           # AppShell, Reusable UI
'''

🤝 Contributing
Contributions are welcome! Please fork the repository and submit a pull request.

Fork the Project

Create your Feature Branch (git checkout -b feature/AmazingFeature)

Commit your Changes (git commit -m 'Add some AmazingFeature')

Push to the Branch (git push origin feature/AmazingFeature)

Open a Pull Request


📄 License
Distributed under the MIT License. See LICENSE for more information.

Developed by mzayan-bit