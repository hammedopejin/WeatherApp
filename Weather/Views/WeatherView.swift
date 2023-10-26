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
    @State private var isRefreshing: Bool
    @State private var currentWeather: CurrentWeatherModel?
    @State private var forecast: WeatherDataModel?
    let dataManager: WeatherDataManager
    @Binding var selectedLocation: LocationResult?
    @State private var isSearchViewPresented: Bool
    @State private var searchText: String
    @State private var shouldShowLocationServiceAlert: Bool
    @ObservedObject private var searchViewModel: SearchViewModel
    
    init(dataManager: WeatherDataManager, selectedLocation: Binding<LocationResult?>) {
        self.dataManager = dataManager
        self._selectedLocation = selectedLocation
        self.locationViewModel = LocationViewModel(dataManager: dataManager)
        self._isRefreshing = State(initialValue: false)
        self._isSearchViewPresented = State(initialValue: false)
        self._searchText = State(initialValue: "")
        self._shouldShowLocationServiceAlert = State(initialValue: false)
        self.searchViewModel = SearchViewModel()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 8) {
                    VStack {
                        Text("Weather Forecast")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color.blue)
                            .padding(.top, 10)
                        
                        if let currentWeather = currentWeather {
                            CurrentWeatherView(model: currentWeather)
                        }
                        Spacer()
                        Spacer()
                        Text("5-Day Forecast")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(.top, 5)
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                if let forecast = forecast {
                                    ForEach(forecast.fiveDayForcast[1...], id: \.date) { forecast in
                                        ForecastCellView(forecast: forecast)
                                        Divider()
                                    }
                                }
                            }
                            .padding()
                        }
                        .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .searchable(text: $searchText) {
                        Button("Search") {
                            // Handle the search button press here
                            searchByCity()
                        }
                    }.background(Color.green)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                    .background(Color.blue.opacity(0.7))
                    .onSubmit {
                        // Handle the search action here
                        searchByCity()
                    }
                    .onAppear {
                        selectedLocation = nil
                        if locationViewModel.authorizationStatus == .notDetermined {
                            locationViewModel.requestLocationAuthorization()
                            Text("Authorization Status: " + (locationViewModel.authorizationStatus?.rawValue.description ?? "Not Determined"))
                                .onReceive(locationViewModel.$authorizationStatus) { newStatus in
                                    
                                    if newStatus == .authorizedWhenInUse || locationViewModel.authorizationStatus == .authorizedAlways {
                                        handleOnAppear()
                                    }
                                }
                        } else if locationViewModel.authorizationStatus == .denied {
                            shouldShowLocationServiceAlert = true
                        } else if locationViewModel.authorizationStatus == .authorizedWhenInUse || locationViewModel.authorizationStatus == .authorizedAlways {
                            handleOnAppear()
                        }
                    }
                    .background(Color(.systemBackground)) // Set the main background color
                    .navigationBarTitle("Weather App", displayMode: .inline)
                    if locationViewModel.authorizationStatus == .denied {
                        Text("Location access is denied. Please enable location services in Settings.")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .onChange(of: selectedLocation) { newLocation, oldLocation in
                    if let location = newLocation {
                        if location != oldLocation {
                            // Fetch data for the newly selected location
                            fetchDataForSelectedLocation(location)
                        }
                    }
                }
                .keyboardType(.webSearch)
                .sheet(isPresented: $isSearchViewPresented) {
                    SearchResultsView(searchResults: $searchViewModel.searchResults, selectedLocation: $selectedLocation, weatherDataManager: dataManager)
                }
            }
            .refreshable {
                isRefreshing = true
                withAnimation {
                    fetchData()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isRefreshing = false
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.white]), startPoint: .top, endPoint: .bottom)
            )
        }
    }
    
    private func fetchDataForSelectedLocation(_ location: LocationResult) {
        dataManager.fetchData(latitude: location.latitude, longitude: location.longitude) { result in
            switch result {
            case .success((let current, let forecast)):
                self.currentWeather = current
                self.forecast = forecast
                print(current, forecast)

            case .failure(let error):
                print(error.localizedDescription)
            }

            // Ensure that isRefreshing is set to false when the refresh is completed
            self.isRefreshing = false
        }
    }
    
    // Function to initiate city search
    private func searchByCity() {
        searchViewModel.parseCityName(searchText)
        self.isSearchViewPresented = true
    }
    
    private func handleOnAppear() {
        if locationViewModel.userLocation != nil {
            fetchData()
        } else {
            locationViewModel.requestLocationAuthorization()
        }
    }
    
    private func fetchData() {
        // Define variables for latitude and longitude
        var latitude: Double
        var longitude: Double
        
        if let location = selectedLocation {
            latitude = location.latitude
            longitude = location.longitude
        } else if let location = locationViewModel.userLocation {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        } else {
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
                    .transition(.opacity) // Add opacity transition for a smooth appearance
            
            } else {
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .onAppear {
                        withAnimation {
                            fetchWeatherIcon()
                        }
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
                    .transition(.opacity) // Add opacity transition for a smooth appearance
            } else {
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .onAppear {
                        withAnimation {
                            fetchWeatherIcon()
                        }
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
