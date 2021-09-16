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
        var convertedDate = ""
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM/dd"
        convertedDate = dateFormatter.string(from: date)
        
        return convertedDate
    }
    
    func timezoneToHourlyTime(timestamp: Int) -> String {
        var time = ""
        
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        time = dateFormatter.string(from: date)
        
        return time
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
