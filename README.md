# 🛍️ GP E-Commerce App

A modern, high-performance e-commerce mobile application built with **Flutter**. This project follows a feature-first architecture and utilizes best practices for state management and responsive UI.

## ✨ Features

- **🔐 Authentication**: Secure user login and registration flows.
- **🏠 Dynamic Home**: Browse featured products, new arrivals, and special offers.
- **📁 Categories**: Easy navigation through product categories.
- **🔍 Product Search**: Quickly find the items you're looking for.
- **💎 Product Details**: Detailed views with descriptions, ratings, and related products.
- **🛒 Shopping Cart**: Seamlessly manage items before checkout.
- **❤️ Favorites**: Save your favorite products for later.
- **💳 Payment Integration**: Streamlined checkout and payment process.
- **👤 User Profile**: Manage account details and order history.
- **🌓 Dark Mode Support**: (Planned/Implemented) Optimized for all lighting conditions.

## 🚀 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [Flutter BLoC / Cubit](https://pub.dev/packages/flutter_bloc)
- **Responsive UI**: [Flutter ScreenUtil](https://pub.dev/packages/flutter_screenutil)
- **Networking**: [Cached Network Image](https://pub.dev/packages/cached_network_image)
- **Typography**: [Google Fonts](https://pub.dev/packages/google_fonts)
- **Model Equality**: [Equatable](https://pub.dev/packages/equatable)

## 🏗️ Architecture

The project follows a **Feature-First Architecture**, ensuring high modularity and scalability.

```text
lib/
├── core/           # Core themes, constants, and utilities
├── features/       # Feature-based modules (Auth, Home, Cart, etc.)
├── models/         # Data models
├── view_models/    # Cubits and state logic
├── views/          # Shared screens and pages
└── widgets/        # Reusable UI components
```

## 🛠️ Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)
- [Dart SDK](https://dart.dev/get-started/sdk)
- An IDE (Android Studio or VS Code)
- A physical device or emulator

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AyaaMohammedsayed/gp_ecommerce.git
   ```

2. **Navigate to the project directory:**
   ```bash
   cd gp_ecommerce
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the application:**
   ```bash
   flutter run
   ```

## 📸 Screenshots

*(Add screenshots of your app here to showcase the UI!)*

## 🤝 Contributing

Contributions are welcome! If you'd like to improve this project, please:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
