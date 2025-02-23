# HandiMobil - Mobile Service Management App

A Flutter mobile application for managing handyman service requests and discoveries. Built with Flutter and Laravel backend.

## Features

- **Discovery Management**

  - Create and manage service discoveries
  - Add detailed customer information
  - Track service costs and pricing
  - Handle multiple images per discovery
  - Manage service items and quantities

- **Customer Information**

  - Store customer details
  - Track customer locations
  - Manage contact information
  - Save service history

- **Service Details**
  - Calculate total costs
  - Handle labor and transportation costs
  - Manage discounts and extra fees
  - Track completion times
  - Set offer validity periods

## Tech Stack

- Frontend: Flutter
- Backend: Laravel
- State Management: GetX
- Storage: Get Storage
- Network: HTTP package
- Image Handling: Image Picker

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK
- Android Studio / Xcode
- Git

### Installation

1. Clone the repository

```bash
git clone https://github.com/fcendesu/handimobil.git
```

2. Navigate to project directory

```bash
cd handimobil
```

3. Install dependencies

```bash
flutter pub get
```

4. Run the app

```bash
flutter run
```

### Environment Setup

Create a `.env` file in the root directory:

```env
API_URL=your_api_url_here
```

## Project Structure

```
lib/
├── controllers/     # GetX controllers
├── models/         # Data models
├── views/          # UI screens and widgets
├── services/       # API services
└── utils/          # Helper functions and constants
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

Project Link: [https://github.com/yourusername/handimobil](https://github.com/fcendesu/handimobil)
