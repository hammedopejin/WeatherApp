//
//  WeatherModel.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import Foundation

struct WeatherModel: Codable {
    let weatherDescription: String
    let temperature: Double
    let icon: String
    let date: Date
}

struct WeatherForecastModel: Codable {
    let dailyForecasts: [WeatherModel]
}

struct CurrentWeatherModel: Codable {
    let currentWeather: WeatherModel
    let forecast: WeatherForecastModel
}
