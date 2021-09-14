//
//  HourlyForecastViewControllerTableViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/01.
//

import UIKit
import SwiftyGif

class HourlyForecastTableViewController: UITableViewController {
    private lazy var weatherViewModel = HourlyForecastViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableViewStyling()
        updateWeather()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherViewModel.numberOfHourlyResults
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyForecastTableViewCell", for: indexPath) as? HourlyForecastTableViewCell
        let hour = weatherViewModel.hourlyWeather?[indexPath.row]
        
        do {
            let gif = try UIImage(gifName: weatherViewModel.iconConverter(id: hour?.weather[0].id ?? 0))
            cell?.iconImageView.setGifImage(gif)
        } catch {
            print(error)
        }

        cell?.hourLabel.text = weatherViewModel.timezoneToHourlyTime(timestamp: hour?.dt ?? 0)
        cell?.descriptionLabel.text = hour?.weather[0].description.capitalized
        cell?.temperatureLabel.text = String(Int(hour?.temp ?? 0)) + "°C"
        cell?.backgroundColor = .clear

        return cell!
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
