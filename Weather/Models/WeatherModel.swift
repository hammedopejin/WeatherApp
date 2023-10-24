//
//  WeatherModel.swift
//  Weather
//
//  Created by Hammed Opejin on 10/23/23.
//

import Foundation


struct WeatherDataModel: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [WeatherListItemModel]
    let city: CityModel
    
    var sortedList: [WeatherListItemModel] {
        return list.sorted(by: {$0.dt < $1.dt})
    }
    
    struct DayModel: Codable {
        let date: Date
        var list: [WeatherListItemModel]
    }
    
    var fiveDayForcast: [DayModel] {
        var temp: [DayModel] = []
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        for item in list {
            guard let dateStr = item.dt_txt.components(separatedBy: " ").first else { continue }
            guard let date = df.date(from: dateStr) else { continue }
            if temp.contains(where: {$0.date == date}) {
                if let foundIndex = temp.firstIndex(where: {$0.date == date}) {
                    temp[foundIndex].list.append(item)
                }
            } else {
                let newDay = DayModel(date: date, list: [item])
                temp.append(newDay)
            }
        }
        
        return temp
    }
}

struct WeatherListItemModel: Codable {
    let dt: Int
    let main: MainWeatherDataModel
    let weather: [WeatherInfoModel]
    let clouds: CloudsModel
    let wind: WindModel
    let visibility: Int
    let pop: Double
    let sys: SysModel
    let dt_txt: String
}

struct MainWeatherDataModel: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let sea_level: Int
    let grnd_level: Int
    let humidity: Int
    let temp_kf: Double
}

struct WeatherInfoModel: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct CloudsModel: Codable {
    let all: Int
}

struct WindModel: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

struct SysModel: Codable {
    let pod: String
}

struct CityModel: Codable {
    let id: Int
    let name: String
    let coord: CoordModel
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}

struct CoordModel: Codable {
    let lat: Double
    let lon: Double
}

//
//struct CurrentWeatherModel: Codable {
//    let currentWeather: WeatherModel
//    let forecast: WeatherForecastModel
//}

struct CurrentWeatherModel: Decodable {
    struct Coords:Decodable {
        let lat: Double
        let lon: Double
    }
    
    struct Weather:Decodable {
        let id: Int32
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }
    
    let coord: Coords
    let main: Main
    let weather: [Weather]
    let dt: Int32
    let timezone: Int32
}

//{
//  "coord": {
//    "lon": -122.4194,
//    "lat": 37.7749
//  },
//  "weather": [
//    {
//      "id": 701,
//      "main": "Mist",
//      "description": "mist",
//      "icon": "50n"
//    }
//  ],
//  "base": "stations",
//  "main": {
//    "temp": 286.52,
//    "feels_like": 286.34,
//    "temp_min": 284.8,
//    "temp_max": 288.07,
//    "pressure": 1011,
//    "humidity": 93
//  },
//  "visibility": 9656,
//  "wind": {
//    "speed": 2.57,
//    "deg": 150
//  },
//  "clouds": {
//    "all": 100
//  },
//  "dt": 1698155749,
//  "sys": {
//    "type": 2,
//    "id": 2017837,
//    "country": "US",
//    "sunrise": 1698157592,
//    "sunset": 1698196857
//  },
//  "timezone": -25200,
//  "id": 5391959,
//  "name": "San Francisco",
//  "cod": 200
//}
