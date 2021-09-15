//
//  ViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/27.
//

import UIKit
import  CoreLocation
import SwiftyGif

final class CurrentLocationViewController: UIViewController, SwiftyGifDelegate {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet private weak var currentLocationButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var currentWeatherTemperatureLabel: UILabel!
    @IBOutlet private weak var searchLabel: UITextField!
    @IBOutlet private weak var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet private weak var currentWeatherIconImageView: UIImageView!
    @IBOutlet private weak var cityLabel: UILabel!
    private let locationManager = CLLocationManager()
    
    private lazy var weatherViewModel = CurrentLocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherViewModel.locationDelegate = self
        weatherViewModel.delegate = self
        setupLabels()
        checkInternetConnection()
        self.currentWeatherIconImageView.delegate = self
        tabBarController?.tabBar.backgroundColor = .clear
    }
    
    private func updateWeather() {
        weatherViewModel.loadWeatherData { _ in
            self.setupLabels()
        }
    }
    
    private func updateWeather(cityName: String) {
        weatherViewModel.loadWeatherData(cityName: cityName) { _ in
            self.setupLabels()
        }
    }
    
    private func setupLabels() {
        do {
            let gif = try UIImage(gifName: weatherViewModel.currentLocationIcon)
            currentWeatherIconImageView.setGifImage(gif)
        } catch {
            print(error)
        }
        
        self.cityLabel.text = weatherViewModel.currentLocationCityName
        self.currentWeatherDescriptionLabel.text = weatherViewModel.currentLocationWeatherDescription
        self.currentWeatherTemperatureLabel.text = self.weatherViewModel.currentLocationTemparature + "°C"
    }
    
    private func checkInternetConnection() {
        if !Reachability.isConnectedToNetwork() {
            self.showAlert(alertTitle: self.weatherViewModel.error,
                           alertMessage: self.weatherViewModel.noInternetMessage,
                           actionTitle: self.weatherViewModel.alertActionTitle)
        }
    }
    
}

extension CurrentLocationViewController: UITextFieldDelegate {
    @IBAction func didTaplocationButton(_ sender: UIButton) {
        updateWeather()
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        guard let city = searchLabel.text else {return}
        searchLabel.text = ""
        updateWeather(cityName: city)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let city = searchLabel.text else {return}
        searchLabel.text = ""
        updateWeather(cityName: city)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchLabel.endEditing(true)
        return true
    }
}

extension CurrentLocationViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherResults) {
        DispatchQueue.main.async {
            self.updateWeather()
        }
    }

    func didFailWithError(error: NSError?) {
        showAlert(alertTitle: self.weatherViewModel.error,
                  alertMessage: self.weatherViewModel.cityAlertMessage,
                  actionTitle: self.weatherViewModel.alertActionTitle)
    }
}

extension CurrentLocationViewController: LocationManagerDelegate {
    func locationNotEnabled(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(alertTitle: weatherViewModel.error, alertMessage: weatherViewModel.locationMessage, actionTitle: weatherViewModel.alertActionTitle)
        updateWeather()
    }
}
