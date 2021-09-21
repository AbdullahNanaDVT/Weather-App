//
//  ViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/27.
//

import UIKit
import SwiftyGif
import MapKit

final class CurrentLocationViewController: UIViewController, SwiftyGifDelegate {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet private weak var currentLocationButton: UIButton!
    @IBOutlet private weak var currentWeatherTemperatureLabel: UILabel!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet private weak var currentWeatherIconImageView: UIImageView!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var searchSuggestionTableView: UITableView!
    private lazy var weatherViewModel = CurrentLocationViewModel()
    private lazy var searchResults = [String]()
    private lazy var searchCompleter = MKLocalSearchCompleter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupLabels()
        checkInternetConnection()
        searchSuggestionTableView.isHidden = true
    }
    
    private func updateWeather() {
        weatherViewModel.loadWeatherData { _ in
            self.setupLabels()
        }
    }
    
    private func updateWeather(cityName: String) {
        weatherViewModel.loadWeatherData(cityName: cityName) { _ in
            DispatchQueue.main.async { [self] in
                if self.weatherViewModel.numberOfWeatherResultsIsEmpty {
                    showAlert(alertTitle: weatherViewModel.error,
                              alertMessage: weatherViewModel.cityAlertMessage,
                              actionTitle: weatherViewModel.alertActionTitle)
                }
                self.setupLabels()
            }
        }
    }
    
    private func setupDelegates() {
        weatherViewModel.delegate = self
        searchSuggestionTableView.delegate = self
        searchSuggestionTableView.dataSource = self
        searchCompleter.delegate = self
        searchBar.delegate = self
        currentWeatherIconImageView.delegate = self
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
    
    @IBAction func didTaplocationButton(_ sender: UIButton) {
        updateWeather()
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
                  alertMessage: error?.localizedDescription ?? weatherViewModel.cityAlertMessage,
                  actionTitle: self.weatherViewModel.alertActionTitle)
    }
}

extension CurrentLocationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchSuggestionTableView.isHidden = false
        if !searchText.isEmpty {
            searchCompleter.queryFragment = searchText
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchSuggestionTableView.isHidden = true
        guard let city = searchBar.text else {return}
        searchBar.text = ""
        updateWeather(cityName: city)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text else {return}
        searchBar.text = ""
        searchBar.resignFirstResponder()
        updateWeather(cityName: city)
    }
}

extension CurrentLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchSuggestionTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchSuggestionTableViewCell
        
        cell?.searchSuggestionLabel.text = self.searchResults[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = self.searchResults[indexPath.row]
        searchBar.text = city
    }
}

extension CurrentLocationViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results.map { $0.title }
        DispatchQueue.main.async {
            self.searchSuggestionTableView.reloadData()
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
