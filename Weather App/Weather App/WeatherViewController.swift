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
            self.iconImageView.image = UIImage(systemName: self.weatherViewModel.icon(conditionID: weather.conditionId))
            self.temparatureLabel.text = weather.temparatureString + "°C"
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func didPresslocationButton(_ sender: UIButton) {
        weatherViewModel.weather()
    }
    
    @IBAction func didPressSearchButton(_ sender: UIButton) {
        if let city = searchLabel.text {
            weatherViewModel.weather(cityName: city)
        }
        searchLabel.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchLabel.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchLabel.text {
            weatherViewModel.weather(cityName: city)
        }
        searchLabel.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
}
