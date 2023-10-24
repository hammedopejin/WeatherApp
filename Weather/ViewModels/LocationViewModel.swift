//
//  LocationViewModel.swift
//  Weather
//
//  Created by Hammed Opejin on 10/24/23.
//

import CoreLocation
import SwiftUI
import Combine

class LocationViewModel: NSObject, ObservableObject {
    @Published var userLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var shouldShowLocationServiceAlert: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    private var locationManager = CLLocationManager()
    private var dataManager: WeatherDataManager // Add a property to hold the data manager

        init(dataManager: WeatherDataManager) {
            self.dataManager = dataManager // Initialize the data manager
            super.init()
            setupLocationManager()
        }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        $authorizationStatus
            .sink { status in
                // Handle authorization status changes here
            }
            .store(in: &cancellables)
    }
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            // Update the authorization status property
            authorizationStatus = status
            
            // Handle authorization changes, if needed
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                // Authorization granted, you can now fetch weather data
                if let location = userLocation {
                    // Fetch weather data using the location
                    dataManager.fetchData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { result in
                        // Handle the completion here
                    }
                }
            default:
                // Handle denied or restricted access
                break
            }
        }
}
