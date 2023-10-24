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
    @State private var currentWeather: CurrentWeatherModel?
    @State private var forecast: WeatherDataModel?
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
            ScrollView {
                LazyVStack {
                    VStack { // Center everything in a VStack
                        Text("Weather Forecast")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color.blue)
                        
                        if let currentWeather = currentWeather {
                            CurrentWeatherView(model: currentWeather)
                        }
                        Spacer()
                        Spacer()
                        Text("5-Day Forecast")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color.blue)
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                if let forecast = forecast {
                                    ForEach(forecast.fiveDayForcast[1...], id: \.date) { forecast in
                                        ForecastCellView(forecast: forecast)
                                        Divider()
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .frame(maxWidth: .infinity) // Center the content in the ScrollView
                    .searchable(text: $searchText) {
                        // Search bar functionality can be added here
                    }
                    .refreshable {
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
                        Text("Location access is denied. Please enable location services in Settings.")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .background(Color(UIColor.systemBackground))
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
            switch result {
            case .success((let current, let forcast)):
                self.currentWeather = current
                self.forecast = forcast
                print(current, forcast)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            // Ensure that isRefreshing is set to false when the refresh is completed
            self.isRefreshing = false
        }
    }
}

struct CurrentWeatherView: View {
    @State private var weatherIcon: UIImage?
    let model: CurrentWeatherModel
    
    func kelvinToCelsius(_ kelvin: Double) -> String {
        return String(format: "%.0f", kelvin - 273.15)
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
                .bold()
                .padding(.top, 2)
            
            Text(model.weather.first?.description ?? "<Error>")
                .font(.title)
                .padding(.top, 2)
            
            Text("\(kelvinToCelsius(model.main.temp))°C")
                .font(.largeTitle)
                .bold()
                .padding(.top, 2)
            
            if let weatherIcon = weatherIcon {
                Image(uiImage: weatherIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            } else {
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .onAppear {
                        fetchWeatherIcon()
                    }
            }
        }
        .padding(10)
        .background(Color.yellow.opacity(0.5))
        .cornerRadius(10)
        .frame(maxWidth: .infinity) // Center within the available space
    }
}

struct ForecastCellView: View {
    let forecast: WeatherDataModel.DayModel
    @State private var weatherIcon: UIImage?
    
    func kelvinToCelsius(_ kelvin: Double) -> String {
        return String(format: "%.0f", kelvin - 273.15)
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
                .font(.title)
                .bold()
                .padding(.top, 2)
            
            if let weatherIcon = weatherIcon {
                Image(uiImage: weatherIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            } else {
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .onAppear {
                        fetchWeatherIcon()
                    }
            }
            
            Text("\(kelvinToCelsius(forecast.list.first?.main.temp ?? 0))°C")
                .font(.title)
                .padding(.top, 2)
        }
        .padding(10)
        .background(Color.yellow.opacity(0.5))
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}
