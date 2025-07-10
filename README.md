# Budget Tracker

A Flutter-based budget tracker application.

## Description

This app helps you manage your finances by tracking your income, expenses, and budgets. It provides a clear overview of your spending habits and helps you make informed financial decisions.

Key features:

*   Expense tracking: Record your daily expenses with categories and descriptions.
*   Budget management: Set monthly budgets for different categories and track your progress.
*   Reports and analytics: Visualize your spending patterns with charts and graphs.
*   Dashboard: Get a quick overview of your current balance, recent transactions, and budget progress.

## Architecture

The app follows a layered architecture:

*   **Presentation Layer:** This layer contains the UI components and widgets that the user interacts with. It's built using Flutter's declarative UI framework.
*   **Business Logic Layer:** This layer contains the core logic of the app, including data validation, calculations, and state management.
*   **Data Layer:** This layer handles data persistence and retrieval. It interacts with local storage or remote APIs to fetch and store data.

## Key Components

*   **Dashboard:** The main screen that provides an overview of the user's financial status.
*   **Expense List:** A screen that displays a list of all expenses, with filtering and sorting options.
*   **Budget Management:** A screen that allows users to set and manage their budgets.
*   **Reports and Analytics:** A screen that provides visualizations of the user's spending patterns.
*   **Profile and Settings:** A screen that allows users to customize the app's settings.

## Data Flow

1.  The user interacts with the UI components in the Presentation Layer.
2.  The UI components trigger events that are handled by the Business Logic Layer.
3.  The Business Logic Layer processes the events and interacts with the Data Layer to fetch or store data.
4.  The Data Layer retrieves data from local storage or remote APIs.
5.  The data is passed back to the Business Logic Layer, which updates the app's state.
6.  The UI components in the Presentation Layer are updated to reflect the new state.

## Setup

### Prerequisites

*   Flutter SDK: Make sure you have Flutter installed on your machine. You can download it from [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install).
*   Android SDK: If you want to run the app on an Android emulator or device, you need to install the Android SDK.
*   XCode: If you want to run the app on an iOS simulator or device, you need to install XCode.

### Installation

1.  Clone the repository:

    ```bash
    git clone https://github.com/Roshan07R/Budget-Tracker.git
    ```
2.  Navigate to the project directory:

    ```bash
    cd Budget-Tracker
    ```
3.  Install dependencies:

    ```bash
    flutter pub get
    ```

### Running the app

```bash
flutter run
```

This command will build and run the app on your connected device or emulator.

## Download

You can download the latest release APK [here](https://github.com/Roshan07R/Budget-Tracker/raw/main/build/app/outputs/apk/release/app-release.apk).

## Usage

*   Add expenses: Tap the "+" button to add a new expense. Enter the amount, category, description, and date.
*   Manage budgets: Go to the "Budget" screen to set monthly budgets for different categories.
*   View reports: Check the "Reports" screen to see charts and graphs of your spending patterns.
*   Customize settings: Go to the "Profile" screen to customize the app's settings.

## Contributing

Contributions are welcome! If you find a bug or have a feature request, please open an issue. If you want to contribute code, please fork the repository and submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
