//
//  WeatherMapViewModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/28.
//

import Foundation
import CoreLocation
import MapKit

final class WeatherMapViewModel: NSObject {
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
            weatherRepository.weatherData(latitude: latitude, longitude: longitude) { result in
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
            weatherRepository.weatherData(latitude: coordinate.latitude, longitude: coordinate.longitude) { result in
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
    
    var currentLocationCityName: String {
        cityName(weatherResults.weather?.timezone ?? "Johannesburg")
    }
    
    var currentLocationTemparature: String {
        String(Int(weatherResults.currentWeather?.temp ?? 0.0))
    }
    
    func cityName(_ city: String) -> String {
        var cityName = ""
        if let range = city.range(of: "/") {
            cityName = String(city[range.upperBound...])
        }
        return cityName.replacingOccurrences(of: "_", with: " ")
    }
}

extension WeatherMapViewModel: CLLocationManagerDelegate {
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
