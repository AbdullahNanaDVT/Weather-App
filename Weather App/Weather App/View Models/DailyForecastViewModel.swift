//
//  DailyForecastViewModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/02.
//

import Foundation
import CoreLocation

final class DailyForecastViewModel: NSObject {
    private let weatherRepository = WeatherRepository()
    weak var delegate: WeatherManagerDelegate?
    private let locationManager = CLLocationManager()
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
    
    func iconConverter(id: Int) -> String {
        weatherResults.conditionIDToIconString(conditionID: id)
    }
    
    var dailyWeather: [Daily]? {
        weatherResults.dailyWeather
    }
    
    var numberOfDailyResults: Int {
        weatherResults.dailyWeather?.count ?? 0
    }
}
