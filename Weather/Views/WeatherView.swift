//
//  WeatherView.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import SwiftUI

struct WeatherView: View {
    
    @State private var isRefreshing = false
    @State private var currentWeather: CurrentWeatherModel = CurrentWeatherModel(currentWeather: TestData.sampleCurrentWeather, forecast: TestData.sampleWeatherForecast) // Initialize with sample data
    @State private var forecast: WeatherForecastModel = TestData.sampleWeatherForecast // Initialize with sample data
    let dataManager: WeatherDataManager // Inject the data manager
    @State private var isSearchViewPresented = false
    @State private var searchText = ""
    
    init(dataManager: WeatherDataManager) {
        self.dataManager = dataManager
        // Initialize 'currentWeather' and 'forecast' with default values or placeholders
        _currentWeather = State(initialValue: CurrentWeatherModel(currentWeather: TestData.sampleCurrentWeather, forecast: TestData.sampleWeatherForecast))
        _forecast = State(initialValue: TestData.sampleWeatherForecast)
        //        _currentWeather = State(initialValue: CurrentWeatherModel(currentWeather: WeatherModel(weatherDescription: "Loading...", temperature: 0, icon: "cloud.sun.fill", date: Date()), forecast: WeatherForecastModel(dailyForecasts: [])))
        //        _forecast = State(initialValue: WeatherForecastModel(dailyForecasts: []))
    }
    
    var body: some View {
        NavigationView {
            List {
                Text("Weather Forecast")
                    .font(.largeTitle)
                // Your weather content here
                CurrentWeatherView(weather: currentWeather.currentWeather)
                
                // ... other forecast cells
                Text("5-Day Forecast")
                    .font(.title)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(forecast.dailyForecasts, id: \.date) { forecast in
                            ForecastCellView(forecast: forecast)
                        }
                    }
                    .padding()
                }
            }
            .refreshable {
                // Handle refresh action here
                isRefreshing = true
                dataManager.fetchData(latitude: 37.7749, longitude: -122.4194) { result in
                    // Handle the completion here
                }
            }
            .onAppear {
                // Load initial data
                dataManager.fetchData(latitude: 37.7749, longitude: -122.4194) { result in
                    // Handle the completion here
                }
            }
            .searchable(text: $searchText) {
                // Perform search based on the entered text
//                search(searchText)
            }
        }
    }
}

struct CurrentWeatherView: View {
    let weather: WeatherModel
    
    var body: some View {
        VStack {
            Text("Today's Weather")
                .font(.title)
            
            Text(weather.weatherDescription)
                .font(.headline)
            
            Text("\(Int(weather.temperature))°C")
                .font(.system(size: 50))
            
            Image(systemName: weather.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
        }
        .padding()
    }
}

struct ForecastCellView: View {
    let forecast: WeatherModel
    
    var body: some View {
        VStack {
            Text(forecast.date, style: .date)
                .font(.caption)
            
            Image(systemName: forecast.icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text("\(Int(forecast.temperature))°C")
                .font(.caption)
        }
    }
}
