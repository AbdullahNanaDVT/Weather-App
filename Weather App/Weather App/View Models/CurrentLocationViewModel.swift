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

class CurrentLocationViewModel: NSObject {
    
    private let weatherRepository = WeatherRepository()
    private var weatherResults = WeatherResults(weather: nil)
    private let locationManager = CLLocationManager()
    weak var delegate: WeatherManagerDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationSetup()
    }
    
    func mapWeatherData(completion: @escaping (WeatherResults) -> Void) {
        if let latitude = locationManager.location?.coordinate.latitude,
           let longitude = locationManager.location?.coordinate.longitude {
            WeatherRepository.shared.fetchData(latitude: latitude, longitude: longitude) { weather in
                let weatherVM = weather
                DispatchQueue.main.async {
                    self.weatherResults = weatherVM
                    completion(weatherVM)
                }
            }
        }
    }
    
    func mapWeatherData(cityName: String, completion: @escaping (WeatherResults) -> Void) {
        getCoordinate(addressString: cityName) { coordinate, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error)
                return
            } else {
                WeatherRepository.shared.fetchData(latitude: coordinate.latitude, longitude: coordinate.longitude) { weather in
                    let weatherVM = weather
                    DispatchQueue.main.async {
                        self.weatherResults = weatherVM
                        completion(weatherVM)
                    }
                }
            }
        }
    }
    
    private func cityFromTimezone(_ city: String) -> String {
        var cityName = ""
        if let range = city.range(of: "/") {
            cityName = String(city[range.upperBound...])
        }
        let name = cityName.replacingOccurrences(of: "_", with: " ")
        return name
    }
    
    var temparature: String {
        String(Int(weatherResults.weather?.current.temp ?? 0.0))
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
    
    var cityName: String {
        cityFromTimezone(weatherResults.weather?.timezone ?? "Johannesburg")
    }
    
    var numberOfWeatherResultsIsEmpty: Bool {
        weatherResults.weather == nil
    }

    var icon: String {
        weatherRepository.iconImage(conditionID: weatherResults.weather?.current.weather[0].id ?? 0)
    }
    
    var date: Int {
        weatherResults.weather?.current.dt ?? 0
    }
    
    var weatherDescription: String {
        weatherResults.weather?.current.weather[0].description.capitalized ?? ""
    }
    
    var clouds: Int {
        weatherResults.weather?.current.clouds ?? 0
    }
    
    var humidity: Int {
        weatherResults.weather?.current.humidity ?? 0
    }
    
    var sunrise: Int {
        weatherResults.weather?.current.sunrise ?? 0
    }
    
    var sunset: Int {
        weatherResults.weather?.current.sunset ?? 0
    }
}

extension CurrentLocationViewModel: CLLocationManagerDelegate {
    func locationSetup() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            print("Location not received")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            locationManager.stopUpdatingLocation()
            self.delegate?.didUpdateWeather(weather: weatherResults)
        }
    }
    
    func getCoordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
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
        print(error)
    }
}
