//
//  DailyForecastViewModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/02.
//

import Foundation
import CoreLocation

final class ForecastViewModel: NSObject {
    private lazy var weatherRepository = WeatherRepository()
    weak var delegate: WeatherManagerDelegate?
    private lazy var locationManager = CLLocationManager()
    private lazy var weatherResults = WeatherResults(weather: nil)
    private lazy var dateFormatter = DateFormatter()
    
    override init() {
        super.init()
    }
    
    func loadWeatherData(completion: @escaping (WeatherResults) -> Void) {
        if let latitude = locationManager.location?.coordinate.latitude,
           let longitude = locationManager.location?.coordinate.longitude {
            WeatherRepository.shared.weatherData(latitude: latitude, longitude: longitude) { result in
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
    
    func timezoneToDate(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        dateFormatter.dateFormat = "EEEE, MM/dd"
        return dateFormatter.string(from: date)
    }
    
    func timezoneToHourlyTime(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func conditionIDToIconString(id: Int) -> String {
        weatherResults.conditionIDToIconString(conditionID: id)
    }
    
    var dailyWeather: [Daily]? {
        weatherResults.dailyWeather
    }
    
    var numberOfDailyWeatherResults: Int {
        weatherResults.dailyWeather?.count ?? 0
    }
    
    var numberOfHourlyWeatherResults: Int {
        weatherResults.hourlyWeather?.count ?? 0
    }
    
    var hourlyWeather: [Hourly]? {
        weatherResults.hourlyWeather
    }
}
