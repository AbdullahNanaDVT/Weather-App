//
//  DailyForecastViewModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/02.
//

import Foundation
import CoreLocation

class DailyForecastViewModel: NSObject {
    private let weatherRepository = WeatherRepository()
    weak var delegate: WeatherManagerDelegate?
    private let locationManager = CLLocationManager()
    private var weatherResults = WeatherResults(weather: nil)
    
    override init() {
        super.init()
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
    
    var dailyWeather: [Daily]? {
        weatherResults.weather?.daily
    }
    
    var numberOfDailyResults: Int {
        weatherResults.weather?.daily.count ?? 0
    }
    
    var humidity: Int {
        weatherResults.weather?.daily[0].humidity ?? 0
    }
    
    var weatherDescription: String {
        weatherResults.weather?.daily[0].weather[0].description.capitalized ?? ""
    }
    
    var clouds: Int {
        weatherResults.weather?.daily[0].clouds ?? 0
    }
    
    var date: Int {
        weatherResults.weather?.daily[0].dt ?? 0
    }
    
    var minTemperature: Double {
        weatherResults.weather?.daily[0].temp.min ?? 0.0
        
    }
    
    var maxTemperature: Double {
        weatherResults.weather?.daily[0].temp.max ?? 0.0
    }
    
    var icon: String {
        weatherResults.weather?.daily[0].weather[0].icon ?? "01d"
    }
}
