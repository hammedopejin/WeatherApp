//
//  SearchResultsView.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import SwiftUI

struct SearchResultsView: View {
    @Binding var searchResults: [LocationResult]
    @Binding var selectedLocation: LocationResult?
    let weatherDataManager: WeatherDataManager

    @State private var shouldPresentWeatherView = false
    @State private var selectedLocationForNavigation: LocationResult?

    var body: some View {
        NavigationView {
            List {
                Text("Search Results")
                    .font(.title)
                ForEach(searchResults, id: \.name) { result in
                    Button(action: {
                        selectedLocationForNavigation = result
                        shouldPresentWeatherView = true
                    }) {
                        SearchResultRow(locationResult: result, selectedLocation: $selectedLocation)
                    }
                }
            }
            .navigationBarTitle("Search Results")
            .background(
                NavigationLink("", destination: WeatherView(dataManager: self.weatherDataManager, selectedLocation: $selectedLocationForNavigation), isActive: $shouldPresentWeatherView)
            )
        }
        .onAppear {
            selectedLocationForNavigation = selectedLocation
        }
    }
}

struct SearchResultRow: View {
    var locationResult: LocationResult
    var selectedLocation: Binding<LocationResult?>
    
    var body: some View {
        HStack {
            Text(locationResult.name)
            Spacer()
            Image(systemName: "arrow.right.circle")
        }
        .onTapGesture {
            selectedLocation.wrappedValue = locationResult
        }
    }
}

struct WeatherViewForLocation: View {
    let locationResult: LocationResult
    let weatherDataManager: WeatherDataManager

    init(weatherDataManager: WeatherDataManager, locationResult: LocationResult) {
        self.weatherDataManager = weatherDataManager
        self.locationResult = locationResult
    }

    var body: some View {
        WeatherView(dataManager: weatherDataManager, selectedLocation: .constant(locationResult))
    }
}
