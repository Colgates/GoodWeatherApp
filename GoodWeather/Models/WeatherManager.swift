//
//  WeatherManager.swift
//  ClimaWeatherApp
//
//  Created by Evgenii Kolgin on 31.10.2020.
//

import Foundation
import Alamofire
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(data: CurrentWeather)
    func didFailWithError()
}

class WeatherManager {

    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityname: String) {
        let urlString = "\(Constants.WEATHER_URL)weather?appid=\(Constants.API_KEY)&q=\(cityname)&units=metric"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(Constants.WEATHER_URL)weather?appid=\(Constants.API_KEY)&lat=\(latitude)&lon=\(longitude)&units=metric"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        AF.request(urlString).validate().responseDecodable(of: CurrentWeather.self) { (response) in
            if let safeData = response.value {
                
                self.delegate?.didUpdateWeather(data: safeData)
            } else {
                print(response.debugDescription)
                self.delegate?.didFailWithError()
            }
        }
    }
}

