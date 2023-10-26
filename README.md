# WeatherApp
Weather Forecast App

[Screen Recording 2023-10-26 at 9.17.49 AM.mov.zip](https://github.com/hammedopejin/WeatherApp/files/13180068/Screen.Recording.2023-10-26.at.9.17.49.AM.mov.zip)


This Weather Forecast App is a simple yet visually appealing iOS application built with SwiftUI and Swift. The app fetches weather data from the OpenWeatherMap API and presents it in an intuitive user interface. It includes current weather conditions, a 5-day forecast, pull-to-refresh functionality, and the ability to search for weather in different locations.

Table of Contents

Running the App
Design Decisions
Challenges Encountered

Running the App

To run the Weather Forecast App on your iOS device or simulator, follow these steps:

Clone or download the repository to your local machine.
Open the project in Xcode by double-clicking the WeatherForecastApp.xcodeproj file.
Ensure you have an active internet connection and a valid Apple Developer account set up in Xcode.
Select your target device (e.g., iPhone or iPad) or a simulator from the device dropdown in Xcode.
Click the "Run" button in the Xcode toolbar to build and launch the app.
Interact with the app to explore current weather conditions, the 5-day forecast, and try the pull-to-refresh functionality.

Design Decisions

User Interface (UI) Design

The UI is designed using SwiftUI, providing a visually pleasing and responsive experience for users.
The main screen displays the current weather conditions, including temperature, weather description, and an icon representing the weather.
A daily forecast section shows the weather forecast for the next 5 days, with each cell displaying the date, weather icon, and temperature range.

Networking

The app integrates the OpenWeatherMap API to fetch weather data. It fetches current weather conditions and a 5-day forecast for a specific location using latitude and longitude.
Robust error handling is implemented to gracefully handle network requests and API response errors.

Data Parsing

JSON responses from the API are parsed into Swift models. Data structures are created to store the current weather data and forecast data accurately.

User Experience (UX)

Smooth transitions and animations enhance the user experience, providing a polished look and feel.
The app allows users to pull down to refresh weather data, making it easy to get the latest updates.
Loading indicators are displayed while fetching data to keep users informed of ongoing operations.

Bonus Features

The app includes a search functionality, enabling users to search for weather in different locations.
It incorporates SwiftUI's built-in animation capabilities to create a more polished and interactive UI.

Challenges Encountered

Implementing the pull-to-refresh functionality required precise handling to ensure data refresh and UI updates worked correctly.
Integrating and authenticating with the OpenWeatherMap API and parsing its responses involved handling various data formats and error scenarios.
Implementing the search functionality and integrating it seamlessly into the existing UI was a challenging task.
Please note that while endeavores had been made to meet the requirements of the assignment, the Weather Forecast App is a simplified demonstration, and further improvements and additional features can be implemented.

Hope you enjoy exploring the Weather Forecast App, and it serves as an illustrative example of SwiftUI, network integration, and UI/UX design for iOS applications. If you have any questions or feedback, feel free to contact. Thank you for your consideration!

[Screen Recording 2023-10-26 at 9.17.49 AM.mov.zip](https://github.com/hammedopejin/WeatherApp/files/13180072/Screen.Recording.2023-10-26.at.9.17.49.AM.mov.zip)
