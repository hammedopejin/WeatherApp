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
    @State private var currentWeather: CurrentWeatherModel? // Initialize with sample data
    @State private var forecast: WeatherDataModel? // Initialize with sample data
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
                if let currentWeather = currentWeather {
                    CurrentWeatherView(model: currentWeather)
                }
                
                Text("5-Day Forecast")
                    .font(.title)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        if let forecast = forecast {
                            ForEach(forecast.fiveDayForcast[1...], id: \.date) { forecast in
                                ForecastCellView(forecast: forecast)
                            }
                        }
                    }
                    .padding()
                }
            }
            .searchable(text: $searchText) {
                //                searchViewModel.search(searchText)
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
        
        dataManager.fetchData(latitude: latitude, longitude: longitude) {
            result in
            // Handle the completion here
            switch result {
            case .success((let current, let forcast)):
                self.currentWeather = current
                self.forecast = forcast
                print(current, forcast)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

struct CurrentWeatherView: View {
    @State private var weatherIcon: UIImage?
    let model: CurrentWeatherModel
    
    func kelvinToCelsius(_ kelvin: Double) -> String {
        return String(format: "%.2f", kelvin - 273.15)
    }
    func fetchWeatherIcon() {
        if let icon = model.weather.first?.icon {
            WeatherNetworkManager.fetchWeatherIcon(iconName: icon) { result in
                switch result {
                case .success(let iconImage):
                    DispatchQueue.main.async {
                        self.weatherIcon = iconImage
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Today's Weather")
                .font(.title)
            
            Spacer()
            Text(model.weather.first?.description ?? "<Error>")
                .font(.headline)
            
            Spacer()
            Text("\(kelvinToCelsius(model.main.temp))°C")
                .font(.system(size: 50))
            
            Spacer()
            if let weatherIcon = weatherIcon {
                Image(uiImage: weatherIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            } else {
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .onAppear {
                        fetchWeatherIcon()
                    }
            }
        }
        .padding()
        .onAppear {
            fetchWeatherIcon()
        }
    }
}

struct ForecastCellView: View {
    let forecast: WeatherDataModel.DayModel
    @State private var weatherIcon: UIImage?
    
    func kelvinToCelsius(_ kelvin: Double) -> String {
        return String(format: "%.2f", kelvin - 273.15)
    }
    
    func fetchWeatherIcon() {
        if let icon = forecast.list.first?.weather.first?.icon {
            WeatherNetworkManager.fetchWeatherIcon(iconName: icon) { result in
                switch result {
                case .success(let iconImage):
                    DispatchQueue.main.async {
                        self.weatherIcon = iconImage
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Text(forecast.date, style: .date)
                .font(.caption)
            Spacer()
            
            if let weatherIcon = weatherIcon {
                Image(uiImage: weatherIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            } else {
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .onAppear {
                        fetchWeatherIcon()
                    }
            }
            
            Spacer()
            Text("\(kelvinToCelsius(forecast.list.first?.main.temp ?? 0))°C")
                .font(.caption)
        }
    }
}
