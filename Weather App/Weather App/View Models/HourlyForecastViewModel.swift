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
    
    func getTime(timestamp: Int) -> String {
        var time = ""
        
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        time = dateFormatter.string(from: date)
        
        return time
    }
    
    func iconConverter(id: Int) -> String {
        weatherRepository.iconImage(conditionID: id)
    }
    
    var numberOfHourlyResults: Int {
        weatherResults.weather?.hourly.count ?? 0
    }
    
    var hourlyWeather: [Hourly]? {
        weatherResults.weather?.hourly
    }
    
    var humidity: Int {
        weatherResults.weather?.hourly[0].humidity ?? 0
    }
    
    var temperature: String {
        String(format: "%.1f", weatherResults.weather?.hourly[0].temp ?? 0.0)
    }
    
    var weatherDescription: String {
        weatherResults.weather?.hourly[0].weather[0].description.capitalized ?? ""
    }
    
    var clouds: Int {
        weatherResults.weather?.hourly[0].clouds ?? 0
    }
    
    var time: String {
        getTime(timestamp: weatherResults.weather?.hourly[0].dt ?? 0)
    }

    var maxTemperature: Double {
        weatherResults.weather?.hourly[0].temp ?? 0.0
    }
    
    var icon: String? {
        //weatherResults.weather?.hourly[0].weather[0].icon ?? "01d"
        weatherRepository.iconImage(conditionID: weatherResults.weather?.hourly[0].weather[0].id ?? 0)
    }
}
