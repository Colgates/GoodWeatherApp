//
//  CurrentWeather.swift
//  ClimaWeatherApp
//
//  Created by Evgenii Kolgin on 31.10.2020.
//

import Foundation

struct CurrentWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let dt: Int
    let id: Int
    let name: String
    
    var dayOfWeekString: String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
    
    var dayOfWeekStringFull: String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
    
    var idString: String {
        return String(id)
    }
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let temp, feelsLike: Double
    let pressure, humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
    }
    
    var temperatureString: String {
        return String(format: "%.0f", temp)
    }
    
    var feelsLikeString: String {
        return String(format: "%.1f", feelsLike)
    }
    
    var pressureString: String {
        return String(pressure)
    }
    
    var humidityString: String {
        return String(humidity)
    }
}

struct Weather: Codable {
    let id: Int
    let description: String
    
    var conditionIdString: String {
        switch id {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
}

struct Wind: Codable {
    let speed: Double
    
    var windString: String {
        return String(format: "%.0f", speed)
    }
}
