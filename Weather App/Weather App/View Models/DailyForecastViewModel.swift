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
    
    func getDate(timestamp: Int) -> String {
        var convertedDate = ""
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM/dd"
        convertedDate = dateFormatter.string(from: date)
        
        return convertedDate
    }
    
    func iconConverter(id: Int) -> String {
        weatherRepository.iconImage(conditionID: id)
    }
    
    var date: String {
        getDate(timestamp: weatherResults.weather?.daily[0].dt ?? 0)
    }
    
    var dailyWeather: [Daily]? {
        weatherResults.weather?.daily
    }
    
    var numberOfDailyResults: Int {
        weatherResults.weather?.daily.count ?? 0
    }
}
