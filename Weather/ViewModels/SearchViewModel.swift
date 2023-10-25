//
//  SearchViewModel.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import SwiftUI
import CoreLocation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchResults: [LocationResult] = []
    private var cancellables: Set<AnyCancellable> = []
    
    func parseCityName(_ cityName: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                print("Geocoding failed with error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let location = placemark.location {
                let result = LocationResult(name: cityName, latitude: location.coordinate.latitude, longitude: location.coordinate.latitude)
                DispatchQueue.main.async {
                    self.searchResults.append(result)
                }
            }
        }
    }
}

struct LocationResult {
    let name: String
    let latitude: Double
    let longitude: Double
}

extension LocationResult: Equatable {
    static func == (lhs: LocationResult, rhs: LocationResult) -> Bool {
        return lhs.name == rhs.name && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
