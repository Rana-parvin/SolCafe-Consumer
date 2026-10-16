# SolCafe ☕

SolCafe is a cross-platform coffee ordering application developed using Flutter and Dart. It provides a user-friendly experience for browsing café products, customising selections, and managing a shopping cart.

The project focuses on responsive UI development, state management, Firebase integration, and maintainable application architecture.

## Features

- **User Authentication:** Login and sign-up using Firebase Authentication.
- **Menu Browsing:** Explore café products organised into categories.
- **Product Customisation:** Select available product sizes and quantities.
- **Cart Management:** Add products, update quantities, and remove items.
- **State Management:** Manage application state using Riverpod.
- **Cloud Database:** Retrieve menu and product information from Cloud Firestore.
- **Responsive UI:** Adapt the interface to different screen sizes.
- **Theme Support:** Light and dark theme options.

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Programming language |
| Riverpod | State management |
| Firebase Authentication | User authentication |
| Cloud Firestore | Cloud database |
| Git | Version control |
| GitHub | Source code hosting |

## Project Structure

SolCafe follows a feature-first project structure with clean architecture principles. The codebase is organised into shared core components and individual application features to support separation of concerns and maintainability.

```text
lib/
├── core/
│   ├── di/                 # Dependency injection
│   ├── error/              # Error handling
│   ├── network/            # Network-related functionality
│   ├── presentation/       # Shared presentation components
│   ├── constants/          # Application constants
│   ├── theme/              # Theme configuration
│   └── utils/              # Shared utilities
│
├── features/
│   ├── auth/               # Authentication
│   ├── cart/               # Shopping cart
│   ├── home/               # Home screen
│   ├── menu/               # Menu and products
│   ├── offers/             # Offers
│   ├── onboarding/         # Onboarding experience
│   ├── order/              # Order-related functionality
│   ├── payment/            # Payment-related functionality
│   ├── referral/           # Referral functionality
│   └── settings/           # Application settings
│
├── firebase_options.dart   # Firebase configuration
└── main.dart               # Application entry point
```

*Note: This is a high-level overview. Individual features may contain presentation, domain, and data layers depending on their implementation.*

## Architecture and State Management

- **Feature-first organisation:** Groups related code by application feature.
- **Clean architecture principles:** Encourages separation of presentation, business logic, and data responsibilities where implemented.
- **Riverpod:** Supports reactive state management and data flows.
- **Core components:** Provide shared dependency injection, error handling, network utilities, and presentation components.
- **Firebase integration:** Provides authentication and cloud-based data storage.

## Getting Started

### Prerequisites

Install the following tools before running the application:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/)
- Git
- A configured Firebase project

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/Rana-parvin/Solcafe-Consumer.git
```

**2. Navigate to the project directory**

```bash
cd Solcafe-Consumer
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Configure Firebase**

Configure Firebase for your target platform using the [official FlutterFire setup guide](https://firebase.google.com/docs/flutter/setup).

Ensure the required Firebase configuration and platform-specific setup are available before running the application.

**5. Run the application**

```bash
flutter run
```

## Project Status

SolCafe is an ongoing project. Authentication, menu browsing, product customisation, and cart management are among its implemented features.

Payment gateway integration and the complete checkout and order-processing workflow are still in progress.

## Learning Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Riverpod Documentation](https://riverpod.dev/)

## Author

**Rana Parvin**

- GitHub: [Rana-parvin](https://github.com/Rana-parvin)
