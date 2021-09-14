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
    @IBOutlet private weak var locationButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var searchLabel: UITextField!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var cityLabel: UILabel!
    private let locationManager = CLLocationManager()
    
    private lazy var weatherViewModel = CurrentLocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherViewModel.locationDelegate = self
        weatherViewModel.delegate = self
        setupLabels()
        checkInternetConnection()
        self.iconImageView.delegate = self
        tabBarController?.tabBar.backgroundColor = .clear
    }
    
    private func updateWeather() {
        weatherViewModel.loadWeatherData { _ in
            self.viewDidLoad()
        }
    }
    
    private func updateWeather(cityName: String) {
        weatherViewModel.loadWeatherData(cityName: cityName) { _ in
            self.viewDidLoad()
        }
    }
    
    private func setupLabels() {
        do {
            let gif = try UIImage(gifName: weatherViewModel.icon)
            iconImageView.setGifImage(gif)
        } catch {
            print(error)
        }
        
        self.cityLabel.text = weatherViewModel.cityName
        //self.iconImageView.image = UIImage(named: weatherViewModel.icon)
        self.descriptionLabel.text = weatherViewModel.weatherDescription
        self.temperatureLabel.text = self.weatherViewModel.temparature + "°C"
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
