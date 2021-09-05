//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/29.
//

import Foundation
import CoreLocation
import MapKit
import SystemConfiguration

class WeatherRepository: NSObject {
    private var weatherResults = WeatherResults(weather: nil)
    static let shared = WeatherRepository()
    
    override init() {
        super.init()
    }
    
    private let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?&units=metric&exclude=minutely"
    
    func fetchData(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler: @escaping (WeatherResults) -> Void) {
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)&appid=\(API.key)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode(WeatherData.self, from: data)
                let currentWeather = WeatherResults(weather: json)
                completionHandler(currentWeather)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
    func iconImage(conditionID: Int) -> String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    var hourlyWeather: [Hourly]? {
        weatherResults.weather?.hourly
    }
    
    var currentWeather: Current? {
        weatherResults.weather?.current
    }
    
    var dailyWeather: [Daily]? {
        weatherResults.weather?.daily
    }
    
    var timezone: String? {
        weatherResults.weather?.timezone
    }
    
    var timezoneOffset: Int? {
        weatherResults.weather?.timezone_offset
    }
}
