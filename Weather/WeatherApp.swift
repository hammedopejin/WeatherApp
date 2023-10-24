//
//  WeatherApp.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import SwiftUI

@main
struct WeatherApp: App {
    let dataManager: WeatherDataManager // Create an instance of WeatherDataManager here

    
    init() {
        // Initialize the data manager with your WeatherNetworkManager instance
        self.dataManager = WeatherDataManager(networkManager: WeatherNetworkManager(apiKey: "7e139cde0811bcf0662486f5ac470fa4"))
    }

    var body: some Scene {
        WindowGroup {
            WeatherView(dataManager: dataManager)
        }
    }
}

//struct TestData {
//    // Sample data for current weather
//    static let sampleCurrentWeather = WeatherModel(
//        weatherDescription: "Sunny",
//        temperature: 25,
//        icon: "sun.max.fill",
//        date: Date()
//    )
//
//    // Sample data for weather forecast
//    static let sampleWeatherForecast = WeatherForecastModel(
//        dailyForecasts: [
//            WeatherModel(weatherDescription: "Rainy", temperature: 20, icon: "cloud.rain.fill", date: Date()),
//            WeatherModel(weatherDescription: "Partly Cloudy", temperature: 22, icon: "cloud.sun.fill", date: Date()),
//            WeatherModel(weatherDescription: "Sunny", temperature: 28, icon: "sun.max.fill", date: Date()),
//            WeatherModel(weatherDescription: "Partly Cloudy", temperature: 22, icon: "cloud.sun.fill", date: Date()),
//            WeatherModel(weatherDescription: "Sunny", temperature: 28, icon: "sun.max.fill", date: Date()),
//            WeatherModel(weatherDescription: "Rainy", temperature: 20, icon: "cloud.rain.fill", date: Date())
//        ]
//    )
//}

