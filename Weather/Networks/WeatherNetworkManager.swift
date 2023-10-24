//
//  WeatherNetworkManager.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import Foundation

class WeatherNetworkManager {
    private let apiKey: String
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeatherModel, Error>) -> Void) {
        // Create the URL for the current weather request.
        let currentWeatherURL = URL(string: "\(baseURL)/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)")!
        
        // Create a URLSession data task to fetch the data.
        let task = URLSession.shared.dataTask(with: currentWeatherURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let currentWeather = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                completion(.success(currentWeather))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchWeatherForecast(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherForecastModel, Error>) -> Void) {
        // Create the URL for the weather forecast request.
        let forecastURL = URL(string: "\(baseURL)/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)")!
        
        // Create a URLSession data task to fetch the data.
        let task = URLSession.shared.dataTask(with: forecastURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let weatherForecast = try JSONDecoder().decode(WeatherForecastModel.self, from: data)
                completion(.success(weatherForecast))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

enum NetworkError: Error {
    case noData
}
