//
//  WeatherView.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
    
    @ObservedObject var locationViewModel: LocationViewModel
    @State private var isRefreshing = false
    @State private var currentWeather: CurrentWeatherModel = CurrentWeatherModel(currentWeather: TestData.sampleCurrentWeather, forecast: TestData.sampleWeatherForecast) // Initialize with sample data
    @State private var forecast: WeatherForecastModel = TestData.sampleWeatherForecast // Initialize with sample data
    let dataManager: WeatherDataManager // Inject the data manager
    @State private var isSearchViewPresented = false
    @State private var searchText = ""
    @State private var shouldShowLocationServiceAlert = false
    @ObservedObject private var searchViewModel = SearchViewModel()
    
    init(dataManager: WeatherDataManager) {
        self.dataManager = dataManager
        locationViewModel = LocationViewModel(dataManager: dataManager)
    }
    
    var body: some View {
        NavigationView {
            List {
                Text("Weather Forecast")
                    .font(.largeTitle)
                CurrentWeatherView(weather: currentWeather.currentWeather)
                
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
            .searchable(text: $searchText) {
                // Perform search based on the entered text
            }
            .refreshable {
                // Handle refresh action here
                isRefreshing = true
                fetchData()
            }
            .onAppear {
                if locationViewModel.authorizationStatus == .notDetermined {
                    locationViewModel.requestLocationAuthorization()
                } else if locationViewModel.authorizationStatus == .denied {
                    shouldShowLocationServiceAlert = true
                } else {
                    handleOnAppear()
                }
            }
            .sheet(isPresented: $isSearchViewPresented) {
                SearchResultsView(searchResults: $searchViewModel.searchResults)
            }
            
            if locationViewModel.authorizationStatus == .denied {
                // Display an error message when authorization is denied
                Text("Location access is denied. Please enable location services in Settings.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
    
    private func handleOnAppear() {
        if locationViewModel.userLocation != nil {
            fetchData()
        } else {
            locationViewModel.requestLocationAuthorization()
        }
    }
    
    private func fetchData() {
        // Fetch data using the provided coordinates or locationViewModel.userLocation
        let latitude: Double
        let longitude: Double
        
        if let location = locationViewModel.userLocation {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        } else {
            // Use default coordinates as a fallback
            latitude = 37.7749
            longitude = -122.4194
        }
        
        dataManager.fetchData(latitude: latitude, longitude: longitude) { result in
            // Handle the completion here
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
