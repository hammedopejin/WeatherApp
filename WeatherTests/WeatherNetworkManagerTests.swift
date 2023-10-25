//
//  WeatherNetworkManagerTests.swift
//  WeatherTests
//
//  Created by Hammed Opejin on 10/25/23.
//

import XCTest
@testable import Weather

class WeatherNetworkManagerTests: XCTestCase {
    // Create an instance of WeatherNetworkManager for testing
    var networkManager: WeatherNetworkManager!

    override func setUp() {
        super.setUp()
        // Initialize your WeatherNetworkManager with a test API key
        networkManager = WeatherNetworkManager(apiKey: "7e139cde0811bcf0662486f5ac470fa4")
    }

    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    func testFetchCurrentWeather() {
        let expectation = XCTestExpectation(description: "Fetching current weather")

        networkManager.fetchCurrentWeather(latitude: 37.7749, longitude: -122.4194) { result in
            switch result {
            case .success(let currentWeather):
                // Assert that the current weather is not nil
                XCTAssertNotNil(currentWeather)
                
                // Check if temperature is in the expected range
                XCTAssert(currentWeather.main.temp >= 10 && currentWeather.main.temp <= 300)

            case .failure(let error):
                XCTFail("Failed to fetch current weather: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        // Set a timeout in case the completion block is not called
        wait(for: [expectation], timeout: 10.0) // Adjust the timeout as needed
    }

    func testFetchWeatherForecast() {
        let expectation = XCTestExpectation(description: "Fetching weather forecast")

        networkManager.fetchWeatherForecast(latitude: 37.7749, longitude: -122.4194) { result in
            switch result {
            case .success(let weatherForecast):
                // Assert that the weather forecast is not nil
                XCTAssertNotNil(weatherForecast)

                // Check if the forecast contains the expected number of days
                XCTAssertGreaterThan(weatherForecast.fiveDayForcast.count, 0)

            case .failure(let error):
                XCTFail("Failed to fetch weather forecast: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        // Set a timeout in case the completion block is not called
        wait(for: [expectation], timeout: 10.0)
    }
}
