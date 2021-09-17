//
//  CurrentLocationViewModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/02.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(weather: WeatherResults)
    func didFailWithError(error: NSError?)
}

final class CurrentLocationViewModel: NSObject {
    private lazy var weatherRepository = WeatherRepository()
    private lazy var locationManager = CLLocationManager()
    weak var delegate: WeatherManagerDelegate?
    private lazy var weatherResults = WeatherResults(weather: nil)
    
    override init() {
        super.init()
        locationManager.delegate = self
        setupLocation()
    }
    
    func loadWeatherData(completion: @escaping (WeatherResults) -> Void) {
        if let latitude = locationManager.location?.coordinate.latitude,
           let longitude = locationManager.location?.coordinate.longitude {
            WeatherRepository.shared.weatherData(latitude: latitude, longitude: longitude) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weather):
                        self.weatherResults = weather
                        completion(weather)
                    case .failure(let error):
                        self.delegate?.didFailWithError(error: error as NSError)
                    }
                }
            }
        }
    }
    
    func loadWeatherData(cityName: String, completion: @escaping (WeatherResults) -> Void) {
        coordinate(addressString: cityName) { [self] coordinate, _ in
            WeatherRepository.shared.weatherData(latitude: coordinate.latitude, longitude: coordinate.longitude) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weather):
                        self.weatherResults = weather
                        completion(weather)
                    case .failure(_):
                        return
                    }
                }
            }
        }
    }
    
    func cityName(_ city: String) -> String {
        var cityName = ""
        if let range = city.range(of: "/") {
            cityName = String(city[range.upperBound...])
        }
        return cityName.replacingOccurrences(of: "_", with: " ")
    }
    
    var error: String {
        NSLocalizedString("ERROR", comment: "")
    }
    
    var noInternetMessage: String {
        NSLocalizedString("NO_INTERNET_MESSAGE", comment: "")
    }
    
    var alertActionTitle: String {
        NSLocalizedString("ALERT_ACTION_TITLE", comment: "")
    }
    
    var cityAlertMessage: String {
        NSLocalizedString("CITY_ALERT_MESSAGE", comment: "")
    }
    
    var currentLocationTemparature: String {
        String(Int(weatherResults.currentWeather?.temp ?? 0.0))
    }
    
    var currentLocationCityName: String {
        cityName(weatherResults.weather?.timezone ?? "Johannesburg")
    }
    
    var numberOfWeatherResultsIsEmpty: Bool {
        weatherResults.currentWeather?.weather == nil
    }

    var currentLocationIcon: String {
        weatherResults.conditionIDToIconString(conditionID: weatherResults.currentWeather?.weather.first?.id ?? 0)
    }
    
    var currentLocationDate: Int {
        weatherResults.currentWeather?.dt ?? 0
    }
    
    var currentLocationWeatherDescription: String {
        weatherResults.currentWeather?.weather.first?.description.capitalized ?? ""
    }
    
    var locationMessage: String {
        NSLocalizedString("LOCATION_NOT_ENABLED", comment: "")
    }
}

extension CurrentLocationViewModel: CLLocationManagerDelegate {
    func setupLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } 
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            locationManager.stopUpdatingLocation()
            self.delegate?.didUpdateWeather(weather: weatherResults)
        }
    }
    
    func coordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
