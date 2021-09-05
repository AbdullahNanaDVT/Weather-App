//
//  HourlyForecastViewControllerTableViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/01.
//

import UIKit

class HourlyForecastTableViewController: UITableViewController {
    private var weatherViewModel = HourlyForecastViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HourlyForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "HourlyForecastTableViewCell")
        updateWeather()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherViewModel.numberOfHourlyResults
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyForecastTableViewCell", for: indexPath) as? HourlyForecastTableViewCell

        let hour = weatherViewModel.hourlyWeather?[indexPath.row]

        cell?.hourLabel.text = weatherViewModel.getTime(timestamp: hour?.dt ?? 0)
        cell?.descriptionLabel.text = hour?.weather[0].description.capitalized
        cell?.iconImageView.image = UIImage(named: hour?.weather[0].icon ?? "01d")
        cell?.temperatureLabel.text = String(hour?.temp ?? 0.0) + "°C"

        return cell!
    }
    
    private func updateWeather() {
        weatherViewModel.mapWeatherData { _ in
            self.tableView.reloadData()
        }
    }
}

extension HourlyForecastTableViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherResults) {
        DispatchQueue.main.async {
            self.updateWeather()
        }
    }
    
    func didFailWithError(error: NSError?) {
        print(error)
    }
}