//
//  HourlyForecastViewControllerTableViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/01.
//

import UIKit

class HourlyForecastTableViewController: UITableViewController {
    private var weatherViewModel = WeatherViewModel()
    private var hourlyWeather = WeatherResults(conditionId: 0, cityName: "", temparature: 0,
                                               timezone_offset: 0, timezone: "", current: nil, daily: nil, hourly: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.delegate = self
        
        weatherViewModel.weather()
        weatherViewModel.locationSetup()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HourlyForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "HourlyForecastTableViewCell")
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hourlyWeather.hourly?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyForecastTableViewCell", for: indexPath) as? HourlyForecastTableViewCell

        let hour = hourlyWeather.hourly?[indexPath.row]

        cell?.hourLabel.text = String(hour?.dt ?? 0)
        cell?.descriptionLabel.text = hour?.weather[0].description
        cell?.iconImageView.image = UIImage(systemName: weatherViewModel.icon(conditionID: hour?.weather[0].id ?? 0))
        cell?.temperatureLabel.text = String(hour?.temp ?? 0.0)

        return cell!
    }
}

extension HourlyForecastTableViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherViewModel, weather: WeatherResults) {
        
        DispatchQueue.main.async {
            self.hourlyWeather = weather
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
