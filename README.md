# Weather App

This is a simple weather app that allows users to search for weather information of a city and view various weather attributes. The app displays the current temperature, weather description, and additional weather attributes such as feels like temperature, humidity, wind speed, and cloudiness.

## Features

- Search for weather information by entering a US city name.
- Displays the current temperature in both Fahrenheit and Celsius units.
- Shows the weather description and an icon representing the weather condition.
- Provides additional weather attributes such as feels like temperature, humidity, wind speed, and cloudiness.
- Displays a collection view of weather attributes for quick reference.

## Getting Started

To run the Weather App locally and test it on your device or simulator, follow these steps:

1. Ensure you have Xcode installed on your macOS device.
2. Clone this repository to your local machine using the following command:

```shell
git clone https://github.com/AndresHernandezGuerra/Coding-Challenge-Weather.git
```

3. Open the project in Xcode by double-clicking the "Coding-Challenge-Weather.xcodeproj" file.
4. Select a target device or simulator from the Xcode toolbar.
5. Build and run the project by clicking the "Run" button or pressing `Cmd+R`.
6. The Weather App will be installed and launched on the selected device or simulator.

## Usage

1. When the app is launched, you will see a search text field at the top to enter a US city name.
2. Enter the name of a city in the search text field and press the "Return" key on the keyboard.
3. The app will fetch weather data for the entered city and display the information on the screen.
4. The main screen shows the city name, current temperature, weather description, and an icon representing the weather condition.
5. Below the main information, you will find a collection view displaying additional weather attributes.
6. You can toggle between Fahrenheit and Celsius temperature units by switching the temperature unit switch at the top-right corner of the screen.
7. The collection view cells show various weather attributes such as feels like temperature, humidity, wind speed, and cloudiness.
8. Scroll horizontally to view all the weather attributes in the collection view.

## Dependencies

The Weather App utilizes the following dependencies:

- UIKit: Apple's framework for building user interfaces.
- CoreLocation: Apple's framework for location services.
- URLSession: Apple's framework for network requests.

These dependencies are included in the iOS SDK and do not require additional installation.

## License

This Weather App is released under the [MIT License](LICENSE).

## Author

This Weather App is developed by Andres Hernandez Guerra.
