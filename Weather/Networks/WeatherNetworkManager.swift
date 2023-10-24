//
//  WeatherNetworkManager.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import UIKit

class WeatherNetworkManager {
    private let apiKey: String
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let iconURL = "https://openweathermap.org/img/wn"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    static func fetchWeatherIcon(iconName: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let iconURL = "https://openweathermap.org/img/wn"
        // Create the URL for the current weather request.
        let currentWeatherURL = URL(string: "\(iconURL)/\(iconName)@2x.png")!
        
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
            
            if let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(error ?? NSError(domain: "Image not retrievable", code: 404)))
            }
        }
        
        task.resume()
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
    
    func fetchWeatherForecast(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherDataModel, Error>) -> Void) {
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
                let weatherForecast = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                
                WeatherNetworkManager.fetchWeatherIcon(iconName: "", completion: {_ in 
                    
                    
                })
                completion(.success(weatherForecast))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func returnLatLongFromCity(location: String) -> Any? {
    
        
        
        
        return nil
    }
}

enum NetworkError: Error {
    case noData
}
