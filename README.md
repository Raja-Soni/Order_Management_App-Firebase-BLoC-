

# Order Management App (Flutter)
  Web App Link: https://order-management-applica-7cae6.web.app
  
## Overview
A full-featured Flutter app for managing orders with real-time updates, advanced filtering, and a dynamic order creation workflow.

## Features

- **Comprehensive Order Management**
  - List, create, delete, and view detailed orders.
  - Users can update the status of the orders.
  - Advanced filtering to quickly access relevant orders.
  - Dynamic New Order page with itemized lists along with item images, auto-calculated totals, and input validation.

- **State Management with BLoC**
  - Separation of UI and business logic using BLoC pattern.
  - Predictable state handling for scalability.
  - Clean architecture ensures maintainability.

- **Firebase Integration**
  - **Authentication:** Secure user login and registration.
  - **Database:** Real-time CRUD operations on orders via Firebase Cloud Firestore.
  - **Local Persistence:** SharedPreferences used for theme persistence and one-time alerts for high-value orders (orders > 10,000 shown once per app reopen).
  - **Enhanced UX:** Sales summaries and notifications to improve user experience.

## Technologies Used
- Flutter & Dart
- BLoC for state management
- Firebase Authentication & Cloud Firestore
- SharedPreferences for local storage

