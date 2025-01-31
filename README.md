<h1 align="center" style="font-weight: bold;">Hawely Currency Converter 💱</h1><p align="center">A modern, cross-platform currency conversion app built with Flutter. Convert currencies in real-time, manage your conversions, and enjoy a seamless user experience with Firebase integration and clean architecture.</p><p align="center"> </p>


💻 Technologies
```bash
- **Flutter**: Cross-platform framework.
- **Dart**: Programming language.
- **MVVM Architecture**: Clean separation of concerns.
- **Provider**: State management.
- **Firebase**: Authentication (Google & Email/Password) and Firestore for data storage.
- **Get It**: Dependency injection.
- **Dio**: HTTP client for API requests.
```


🚀 Getting Started
Prerequisites
1. Flutter SDK (version 3.13.0 or later):

  -Download from Flutter's official website.

  -Add Flutter to your PATH:
  ```bash
    export PATH="$PATH:[PATH_TO_FLUTTER]/flutter/bin"
  ```
-Verify installation
  ```bash
      flutter --version
  ```

 2. IDE:

    -  VS Code: Install Flutter and Dart extensions.

    -  Android Studio: Install Flutter and Dart plugins.
   
3. Firebase Setup:

    - Create a Firebase project at Firebase Console.

    - Add Android, iOS, and web apps to your Firebase project.

    - Download the google-services.json (for Android) and GoogleService-Info.plist (for iOS) files and place them in the     
      appropriate directories.


 4. Installation:
      - Clone the repository:
        ```bash
              git clone https://github.com/Marwan1137/hawely.git
            
      - Navigate to the project:
        ```bash
              cd hawely
            

      - Install dependencies:
        ```bash
              flutter pub get
            
      - Run the app:
         ```bash
              flutter run
           

🏗 Project Structure

```bash           
lib/
├── core/                  # Core configurations
│   ├── constants/         # App constants
│   ├── network/           # HTTP client and API services
│   └── service_locator/   # Dependency injection (Get It)
├── features/              # App features
│   ├── auth/              # Authentication (Firebase Auth)
│   │   ├── models/        # Auth models
│   │   ├── viewmodels/    # Auth business logic
│   │   └── views/         # Auth UI
│   ├── currency/          # Currency conversion feature
│   │   ├── models/        # Currency models
│   │   ├── viewmodels/    # Conversion logic
│   │   └── views/         # Conversion UI
│   └── history/           # Conversion history (Firestore)
├── main.dart              # App entry point
 ```


✨ Key Features
1. Real-Time Currency Conversion:

```bash
- Fetch up-to-date exchange rates using a reliable API.
- Convert between multiple currencies instantly.
```

2. User Authentication:

```bash
- Sign in with Google or Email/Password using Firebase Authentication.
- Secure and seamless login experience.
```


3. Conversion History:

```bash
- Access your data across devices.
```

4. Clean Architecture (MVVM):
```bash
- Separation of concerns for better maintainability.
- Scalable and testable codebase.
```

5. State Management with Provider:
```bash
- Efficient state updates and UI rendering.
```

6. Dependency Injection with Get It:
```bash
- Simplified dependency management.
```

🛠 Support
```bash
- For issues or questions:
  - Email: marwan.hakil79@gmail.com
  - GitHub Issues: [Open an Issue](https://github.com/Marwan1137/hawely/issues)
```

📜 License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.



  
