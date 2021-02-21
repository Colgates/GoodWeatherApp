//
//  WeatherVIewController+Alert.swift
//  GoodWeather
//
//  Created by Evgenii Kolgin on 04.11.2020.
//

import UIKit

extension WeatherViewController {
    
    func presentSearchAlertController(withTitle title:String?, message:String?, style:UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addTextField { (textField) in
            let cities = ["San Francisco", "Moscow", "New York", "Stambul"]
            textField.placeholder = cities.randomElement()
        }
        let search = UIAlertAction(title: "Search", style: .default) { (action) in
            let textField = alert.textFields?.first
            guard let cityName = textField?.text else {return}
            if cityName != "" {

                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(search)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(with message:String) {
        let alert = UIAlertController(title: "😣", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            self.locationManager.requestLocation()
        }))
        present(alert, animated: true)
    }
}
