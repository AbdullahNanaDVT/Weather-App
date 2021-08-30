//
//  ViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/27.
//

import UIKit

class WeatherViewController: UIViewController {
    private var weatherViewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.delegate = self
        
        weatherViewModel.weather()
        weatherViewModel.locationSetup()
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherViewModel, weather: WeatherModel) {
        DispatchQueue.main.async {
//            self.temperatureLabel.text = weather.temparatureString
//            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
//            self.cityLabel.text = weather.cityName
            print(weather)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
