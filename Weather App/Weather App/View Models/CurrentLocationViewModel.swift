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

protocol LocationManagerDelegate: AnyObject {
    func locationNotEnabled(_ manager: CLLocationManager, didFailWithError error: Error)
}

final class CurrentLocationViewModel: NSObject {
    private let weatherRepository = WeatherRepository()
    private lazy var weatherResults = WeatherResults(weather: nil)
    private let locationManager = CLLocationManager()
    weak var delegate: WeatherManagerDelegate?
    weak var locationDelegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationSetup()
    }
    
    func loadWeatherData(completion: @escaping (WeatherResults) -> Void) {
        if let latitude = locationManager.location?.coordinate.latitude,
           let longitude = locationManager.location?.coordinate.longitude {
            WeatherRepository.shared.fetchData(latitude: latitude, longitude: longitude) { result in
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
        coordinate(addressString: cityName) { [self] coordinate, error in
            if error != nil {
                locationDelegate?.locationNotEnabled(locationManager, didFailWithError: error!)
                return
            } else {
                WeatherRepository.shared.fetchData(latitude: coordinate.latitude, longitude: coordinate.longitude) { result in
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
    }
    
    private func cityFromTimezone(_ city: String) -> String {
        var cityName = ""
        if let range = city.range(of: "/") {
            cityName = String(city[range.upperBound...])
        }
        let name = cityName.replacingOccurrences(of: "_", with: " ")
        return name
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
    
    var temparature: String {
        String(Int(weatherResults.weather?.current.temp ?? 0.0))
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
    
    var locationMessage: String {
        NSLocalizedString("LOCATION_NOT_ENABLED", comment: "")
    }
}

extension CurrentLocationViewModel: CLLocationManagerDelegate {
    func locationSetup() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            // swiftlint:disable force_cast
            self.locationDelegate?.locationNotEnabled(locationManager, didFailWithError: error as! Error)
            // swiftlint:enable force_cast
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
        self.locationDelegate?.locationNotEnabled(locationManager, didFailWithError: error)
    }
}
