//
//  ViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/27.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchLabel: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temparatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    private var weatherViewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.delegate = self
        
        weatherViewModel.weather()
        weatherViewModel.locationSetup()
    }
}

extension WeatherViewController: WeatherManagerDelegate {

    func didUpdateWeather(_ weatherManager: WeatherViewModel, weather: WeatherResults) {
        DispatchQueue.main.async {
            let cityName = self.weatherViewModel.cityFromTimezone(weather.cityName)
            self.cityLabel.text = cityName
            self.iconImageView.image = UIImage(systemName: weather.conditionName)
            self.temparatureLabel.text = weather.temparatureString + "°C"
            print(weather)
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}
