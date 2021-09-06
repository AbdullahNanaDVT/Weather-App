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
}
