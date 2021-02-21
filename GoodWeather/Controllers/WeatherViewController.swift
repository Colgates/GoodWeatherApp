//
//  ViewController.swift
//  ClimaWeatherApp
//
//  Created by Evgenii Kolgin on 31.10.2020.
//

import UIKit
import CoreLocation
import WatchConnectivity

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var launchingLabel: UILabel!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    var cityNameId = ""
    
    var notificationObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        notificationObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name("GetData"), object: nil, queue: nil, using: { (_) in
            self.weatherManager.fetchWeather(cityname: self.cityLabel.text ?? "Irkutsk")
            // when city name consists from two words will be error
        })
    }
    
    
    
    func sendDataToWatch(temp: String, cityName: String, condition: String, description: String) {
        if WCSession.isSupported() {
            
            let data = ["temp": temp, "city": cityName, "condition": condition, "description": description]
            
            do {
                try WCSession.default.updateApplicationContext(data)
            } catch {
                print("error")
            }
        }
    }
    
    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func detailsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toDetailVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.url = cityNameId
        }
    }
    
}


//MARK: - TextFieldDelegate Methods

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchButton(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let cityName = searchTextField.text {
            
            let city = cityName.split(separator: " ").joined(separator: "%20")
            weatherManager.fetchWeather(cityname: city)
        }
        
        searchTextField.text = ""
        textField.placeholder = "Search"
    }
    
    
}

//MARK: - WeatherManagerDelegate methods

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(data: CurrentWeather) {
        DispatchQueue.main.async { [self] in
            
            launchingLabel.alpha = 0
            
            if data.main.temp < 0 {
                backgroundImage.image = UIImage(named: "cloud.snow")
            } else {
                backgroundImage.image = UIImage(named: data.weather[0].conditionIdString)
            }
            
            conditionImageView.image = UIImage(systemName: data.weather[0].conditionIdString)
            temperatureLabel.text = data.main.temperatureString
            feelsLikeLabel.text = data.main.feelsLikeString
            humidityLabel.text = data.main.humidityString
            pressureLabel.text = data.main.pressureString
            cityLabel.text = data.name
            descriptionLabel.text = data.weather[0].description
            windSpeedLabel.text = data.wind.windString
            cityNameId = data.idString
            
            sendDataToWatch(temp: data.main.temperatureString, cityName: data.name, condition: data.weather[0].conditionIdString, description: data.weather[0].description)

            
            // pass data to weeklyviewcontroller
            let vc = self.tabBarController!.viewControllers![1] as! WeeklyViewController
            vc.lat = data.coord.lat
            vc.lon = data.coord.lon
            vc.name = data.name
            vc.desc = data.weather[0].description
            vc.date = data.dayOfWeekStringFull
            vc.temp = data.main.temperatureString
            vc.condString = data.weather[0].conditionIdString
        }
    }
    
    func didFailWithError() {
        showAlert(with: "Sorry, we can do nothing without internet connection. Probably, we could send you the forecast by post pigeons, but it would be very long.")
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
        presentSearchAlertController(withTitle: "😞", message: "Sorry, we can't find you or somthing gone wrong with GPS, let's try to fix it manually. Please type the place weather you are interested in.", style: .alert) {[unowned self] city in
            
            weatherManager.fetchWeather(cityname: city)
            
        }
    }
}
