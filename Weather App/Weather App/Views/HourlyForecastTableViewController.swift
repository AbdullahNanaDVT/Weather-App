//
//  HourlyForecastViewControllerTableViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/01.
//

import UIKit
import SwiftyGif

final class HourlyForecastTableViewController: UITableViewController {
    private lazy var weatherViewModel = HourlyForecastViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableViewStyling()
        updateWeather()
    }
    
    private func tableViewStyling() {
        tableView.backgroundView = UIImageView(image: UIImage(named: "sun"))
        tableView.register(UINib(nibName: "HourlyForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "HourlyForecastTableViewCell")
        tableView.allowsSelection = false
    }
    
    private func updateWeather() {
        weatherViewModel.loadWeatherData { _ in
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
        print(error ?? NSError())
    }
}

extension HourlyForecastTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherViewModel.numberOfHourlyResults
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyForecastTableViewCell", for: indexPath) as? HourlyForecastTableViewCell
        let hour = weatherViewModel.hourlyWeather?[indexPath.row]
        
        do {
            let gif = try UIImage(gifName: weatherViewModel.iconConverter(id: hour?.weather.first?.id ?? 0))
            cell?.hourlyWeatherIconImageView.setGifImage(gif)
        } catch {
            print(error)
        }
        
        cell?.hourlyWeatherTimeLabel.text = weatherViewModel.timezoneToHourlyTime(timestamp: hour?.dt ?? 0)
        cell?.hourlyWeatherDescriptionLabel.text = hour?.weather.first?.description.capitalized
        cell?.hourlyWeatherTemperatureLabel.text = String(Int(hour?.temp ?? 0)) + "°C"
        cell?.backgroundColor = .clear
        
        return cell!
    }
}
