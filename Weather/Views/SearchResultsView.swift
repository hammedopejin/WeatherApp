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
    @State private var temporarySelectedLocation: LocationResult?
    @State private var shouldPresentWeatherView = false
    
    init(searchResults: Binding<[LocationResult]>, selectedLocation: Binding<LocationResult?>, weatherDataManager: WeatherDataManager) {
        self._searchResults = searchResults
        self._selectedLocation = selectedLocation
        self.weatherDataManager = weatherDataManager
    }
    
    var body: some View {
        NavigationView {
            List {
                Text("Search Results")
                    .font(.title)
                ForEach(searchResults, id: \.name) { result in
                    NavigationLink(destination: WeatherView(dataManager: self.weatherDataManager, selectedLocation: $selectedLocation)) {
                        SearchResultRow(locationResult: result, selectedLocation: $selectedLocation)
                    }
                }
            }
            .navigationBarTitle("Search Results")
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
    @State var locationResult: LocationResult?
    let weatherDataManager: WeatherDataManager

    init(weatherDataManager: WeatherDataManager, locationResult: LocationResult?) {
        self.weatherDataManager = weatherDataManager
        self._locationResult = State(initialValue: locationResult)
    }

    var body: some View {
        WeatherView(dataManager: weatherDataManager, selectedLocation: $locationResult)
    }
}
