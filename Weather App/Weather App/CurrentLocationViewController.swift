//
//  ViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/27.
//

import UIKit

class CurrentLocationViewController: UIViewController {
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchLabel: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temparatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    private var weatherViewModel = CurrentLocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherViewModel.delegate = self
        weather()
    }
    
    func updateWeather() {
        weatherViewModel.mapWeatherData { _ in
            self.viewDidLoad()
        }
    }
    
    func updateWeather(cityName: String) {
        weatherViewModel.mapWeatherData(cityName: cityName) { _ in
            self.viewDidLoad()
        }
    }
    
    func weather() {
        self.cityLabel.text = weatherViewModel.cityName
        self.iconImageView.image = UIImage(named: weatherViewModel.icon ?? "01d")
        self.temparatureLabel.text = self.weatherViewModel.temparature + "°C"
    }
}

extension CurrentLocationViewController: UITextFieldDelegate {
    
    @IBAction func didPresslocationButton(_ sender: UIButton) {
        updateWeather()
    }
    
    @IBAction func didPressSearchButton(_ sender: UIButton) {
        if let city = searchLabel.text {
            updateWeather(cityName: city)
        }
        searchLabel.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchLabel.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchLabel.text {
            updateWeather(cityName: city)
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

extension CurrentLocationViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherResults) {
        DispatchQueue.main.async {
            self.updateWeather()
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}
