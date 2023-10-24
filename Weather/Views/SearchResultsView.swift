//
//  SearchResultsView.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import SwiftUI

struct SearchResultsView: View {
    @Binding var searchResults: [LocationResult]

    var body: some View {
        List {
            Text("Search Results")
                .font(.title)
            ForEach(searchResults, id: \.name) { result in
                SearchResultRow(locationResult: result)
            }
        }
        .navigationBarTitle("Search Results")
    }
}

struct SearchResultRow: View {
    var locationResult: LocationResult

    var body: some View {
        NavigationLink(destination: WeatherViewForLocation(locationResult: locationResult)) {
            HStack {
                Text(locationResult.name)
                Spacer()
                Image(systemName: "arrow.right.circle")
            }
        }
    }
}

struct WeatherViewForLocation: View {
    var locationResult: LocationResult
    var weatherDataManager: WeatherDataManager

    init(locationResult: LocationResult) {
        self.locationResult = locationResult
        self.weatherDataManager = WeatherDataManager(networkManager: WeatherNetworkManager(apiKey: "7e139cde0811bcf0662486f5ac470fa4")) // Initialize your WeatherNetworkManager
    }

    var body: some View {
        WeatherView(dataManager: weatherDataManager)
    }
}
