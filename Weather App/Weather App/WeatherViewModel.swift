//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/29.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManager: WeatherViewModel, weather: WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherViewModel: NSObject {
    let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?&units=metric&exclude=minutely"
    
    weak var delegate: WeatherManagerDelegate?
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationSetup()
    }
    
    func weather() {
        if let latitude = locationManager.location?.coordinate.latitude,
           let longitude = locationManager.location?.coordinate.longitude {
            performRequest(latitude: latitude, longitude: longitude)
        }
    }
    
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
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherDataModel.self, from: weatherData)
            let current = decodedData.current
            let daily = decodedData.daily
            let hourly = decodedData.hourly
            
            let id = decodedData.current.weather[0].id
            let temp = decodedData.current.temp
            let name = decodedData.timezone
            
            let weather = WeatherModel(conditionId: id, cityName: name, temparature: temp, current: current, daily: daily, hourly: hourly)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
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
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
