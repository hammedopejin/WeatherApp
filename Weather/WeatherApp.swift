//
//  WeatherApp.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import SwiftUI

@main
struct WeatherApp: App {
    @State private var selectedLocation: LocationResult? // Create a State variable for selectedLocation
    let dataManager = WeatherDataManager(networkManager: WeatherNetworkManager(apiKey: "7e139cde0811bcf0662486f5ac470fa4"))

    var body: some Scene {
        WindowGroup {
            WeatherView(dataManager: dataManager, selectedLocation: $selectedLocation) // Pass the State variable as a Binding
        }
    }
}
