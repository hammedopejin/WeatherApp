//
//  SearchViewModel.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import Combine

class SearchViewModel: ObservableObject {
    @Published var searchResults: [LocationResult] = []
    private var cancellables: Set<AnyCancellable> = []

    func search(_ searchText: String) {
        // Simulate a search API call (replace with a real API call)
        performSearchAPIRequest(query: searchText)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] results in
                    self?.searchResults = results
                  })
            .store(in: &cancellables)
    }

    // Simulated API request
    private func performSearchAPIRequest(query: String) -> AnyPublisher<[LocationResult], Never> {
        // For this example, we simulate results based on a few hard-coded locations.
        
        let locations: [LocationResult] = [
            LocationResult(name: "New York", latitude: 40.7128, longitude: -74.0060),
            LocationResult(name: "Los Angeles", latitude: 34.0522, longitude: -118.2437),
            LocationResult(name: "Chicago", latitude: 41.8781, longitude: -87.6298),
        ]

        let filteredLocations = locations.filter { $0.name.lowercased().contains(query.lowercased()) }
        return Just(filteredLocations).eraseToAnyPublisher()
    }
}

struct LocationResult {
    let name: String
    let latitude: Double
    let longitude: Double
}
