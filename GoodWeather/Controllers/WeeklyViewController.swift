//
//  WeeklyViewController.swift
//  GoodWeather
//
//  Created by Evgenii Kolgin on 02.11.2020.
//

import UIKit
import Alamofire

class WeeklyViewController: UIViewController {
    
    var result: WeeklyWeather?
    
    var lat: Double?
    var lon: Double?
    
    var name: String?
    var desc: String?
    var date: String?
    var temp: String?
    var condString: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var todayTempLabel: UILabel!
    @IBOutlet weak var todayCondImage: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.register(CustomViewCell.nib(), forCellReuseIdentifier: CustomViewCell.identifier)
        if let safeLat = lat, let safeLon = lon {
            fetchWeeklyWeather(latitude: safeLat, longitude: safeLon)
        }
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //refresh data control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        //end
    }
    
    //refresh data method
    @objc func didPullToRefresh() {
        // re-fetch data
        if let safeLat = lat, let safeLon = lon {
            fetchWeeklyWeather(latitude: safeLat, longitude: safeLon)
        }
        updateUI()
    }
    
    
    func fetchWeeklyWeather(latitude: Double, longitude: Double) {
        let geoString = "\(Constants.WEATHER_URL)onecall?lat=\(latitude)&lon=\(longitude)&exclude=current,minutely,hourly&appid=\(Constants.API_KEY)&units=metric"
        AF.request(geoString).responseDecodable(of: WeeklyWeather.self) { (response) in
            if let safeData = response.value {
                self.result = safeData
            }
            else {
                print("error")
            }
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()  //refresh data in tableview
                self.tableView.reloadData()
            }
        }
    }
    
    func updateUI() {
        
        if let safeTemp = temp {
            if safeTemp.contains("-") {
                backgroundImageView.image = UIImage(named: "cloud.snow")
            }
            else {
                backgroundImageView.image = UIImage(named: condString ?? "cloud")
            }
            
            cityNameLabel.text = name
            descriptionLabel.text = desc
            todayDateLabel.text = date
            todayTempLabel.text = temp
            todayCondImage.image = UIImage(systemName: condString ?? "cloud")
        }
    }
}
//MARK: - TableViewDataSource and Delegate methods

extension WeeklyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return result?.daily.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomViewCell.identifier, for: indexPath) as! CustomViewCell
        
        if let model = result?.daily[indexPath.row] {
            cell.customCellImageView.image = UIImage(systemName: model.weather[0].conditionIdString)
            cell.weekDayLabel.text = model.dayOfWeekString
            cell.dayTempLabel.text = model.temp.temperatureDayString
            cell.nightTempLabel.text = model.temp.temperatureNightString
            cell.descriptionLabel.text = model.weather[0].description
        }
        return cell
    }
}
