//
//  WeeklyWetaher.swift
//  GoodWeather
//
//  Created by Evgenii Kolgin on 02.11.2020.
//

import Foundation

struct WeeklyWeather: Codable {
    let daily: [Daily]
}

struct Daily: Codable {
    let dt: Int
    let temp: Temp
    let weather: [WeatherWeek]
    
    var dayOfWeekString: String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E" //Specify your format that you want
        return dateFormatter.string(from: date)
    }
}

struct Temp: Codable {
    let day, night: Double
    
    var temperatureDayString: String {
        return String(format: "%.0f", day)
    }
    var temperatureNightString: String {
        return String(format: "%.0f", night)
    }
}

struct WeatherWeek: Codable {
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

