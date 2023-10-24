//
//  WeatherDataManager.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import Foundation

class WeatherDataManager {
    let networkManager: WeatherNetworkManager // Assume you have a WeatherNetworkManager
    
    init(networkManager: WeatherNetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeatherModel, Error>) -> Void) {
        // Implement current weather fetching using the network manager
    }
    
    func fetchWeatherForecast(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherForecastModel, Error>) -> Void) {
        // Implement weather forecast fetching using the network manager
    }
    
    func fetchData(latitude: Double, longitude: Double, completion: @escaping (Result<(CurrentWeatherModel, WeatherForecastModel), Error>) -> Void) {
           // Fetch current weather
           networkManager.fetchCurrentWeather(latitude: latitude, longitude: longitude) { result in
               switch result {
               case .success(let currentWeather):
                   // After fetching the current weather, fetch the forecast
                   self.networkManager.fetchWeatherForecast(latitude: latitude, longitude: longitude) { result in
                       switch result {
                       case .success(let weatherForecast):
                           completion(.success((currentWeather, weatherForecast)))
                       case .failure(let error):
                           completion(.failure(error))
                       }
                   }
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
    
}
