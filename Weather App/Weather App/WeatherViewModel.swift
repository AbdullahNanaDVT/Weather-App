//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/29.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManager: WeatherViewModel, weather: WeatherResults)
    func didFailWithError(error: Error)
}


class WeatherViewModel: NSObject {
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationSetup()
    }
    
    private let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?&units=metric&exclude=minutely"
    
    weak var delegate: WeatherManagerDelegate?
    
    func performRequest(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)&appid=\(API.key)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherResults? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let current = decodedData.current
            let daily = decodedData.daily
            let hourly = decodedData.hourly
            let timezoneOffset = decodedData.timezone_offset
            let timezone = decodedData.timezone
            
            let id = decodedData.current.weather[0].id
            let temp = decodedData.current.temp
            let name = decodedData.timezone
            
            let weather = WeatherResults(conditionId: id, cityName: name, temparature: temp, timezone_offset: timezoneOffset,
                        timezone: timezone, current: current, daily: daily, hourly: hourly)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func weather() {
        if let latitude = locationManager.location?.coordinate.latitude,
           let longitude = locationManager.location?.coordinate.longitude {
           performRequest(latitude: latitude, longitude: longitude)
        }
    }
    
    func weather(cityName: String) {
        getCoordinate(addressString: cityName) { coordinate, error in
            if error != nil {
                print(error?.localizedDescription ?? "Could not find location")
                return
            } else {
                self.performRequest(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
        }
        if let latitude = locationManager.location?.coordinate.latitude,
           let longitude = locationManager.location?.coordinate.longitude {
            performRequest(latitude: latitude, longitude: longitude)
        }
    }
    
    func cityFromTimezone(_ city: String) -> String {
        var cityName = ""
        if let range = city.range(of: "/") {
            cityName = String(city[range.upperBound...])
        }
        let name = cityName.replacingOccurrences(of: "_", with: " ")
        return name
    }
}

extension WeatherViewModel: CLLocationManagerDelegate {
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
            weather()
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
