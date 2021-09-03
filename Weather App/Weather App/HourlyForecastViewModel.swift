//
//  HourlyForecastViewModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/02.
//

import Foundation
import CoreLocation

class HourlyForecastViewModel: NSObject {
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
            weatherRepository.fetchData(latitude: latitude, longitude: longitude) { weather in
                let weatherVM = weather
                DispatchQueue.main.async {
                    self.weatherResults = weatherVM
                    completion(weatherVM)
                }
            }
        }
    }
    
    var hourlyWeather: [Hourly]? {
        weatherResults.weather?.hourly
    }
    
    var humidity: Int? {
        weatherResults.weather?.hourly[0].humidity
    }
    
    var weatherDescription: String? {
        weatherResults.weather?.hourly[0].weather[0].description
    }
    
    var clouds: Int? {
        weatherResults.weather?.hourly[0].clouds
    }
    
    var hour: Int? {
        weatherResults.weather?.hourly[0].dt
    }

    var maxTemperature: Double? {
        weatherResults.weather?.hourly[0].temp
    }
    
    var icon: String? {
        weatherResults.weather?.hourly[0].weather[0].icon
    }
}
