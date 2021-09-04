//
//  ViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/27.
//

import UIKit
import Network

class CurrentLocationViewController: UIViewController {
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    private var weatherViewModel = CurrentLocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherViewModel.delegate = self
        weather()
        checkInternetConnection()
    }
    
    private func updateWeather() {
        weatherViewModel.mapWeatherData { _ in
            self.viewDidLoad()
        }
    }
    
    private func updateWeather(cityName: String) {
        weatherViewModel.mapWeatherData(cityName: cityName) { _ in
            self.viewDidLoad()
        }
    }
    
    private func weather() {
        self.cityLabel.text = weatherViewModel.cityName
        self.iconImageView.image = UIImage(named: weatherViewModel.icon)
        self.descriptionLabel.text = weatherViewModel.weatherDescription
        //self.temparatureLabel.text = self.weatherViewModel.temparature + "°C"
    }
    
    private func checkInternetConnection() {
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                DispatchQueue.main.async {
                    self.showAlert(alertTitle: "No internet", alertMessage: "Please connect to the internet", actionTitle: "Okay")
                }
            }
        }
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        
        monitor.cancel()
    }
}

extension CurrentLocationViewController: UITextFieldDelegate {
    
    @IBAction func didPresslocationButton(_ sender: UIButton) {
        updateWeather()
    }
    
    @IBAction func didPressSearchButton(_ sender: UIButton) {
        guard let city = searchLabel.text else {return}
        searchLabel.text = ""
        updateWeather(cityName: city)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let city = searchLabel.text else {return}
        searchLabel.text = ""
        updateWeather(cityName: city)
    }
}

extension CurrentLocationViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherResults) {
        DispatchQueue.main.async {
            self.updateWeather()
        }
    }

    func didFailWithError(error: NSError?) {
        showAlert(alertTitle: "Invalid City", alertMessage: "Please enter a valid city", actionTitle: "Okay")
    }
}
