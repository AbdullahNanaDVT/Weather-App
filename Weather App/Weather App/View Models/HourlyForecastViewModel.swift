//
//  HourlyForecastViewModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/02.
//

import Foundation
import CoreLocation

final class HourlyForecastViewModel: NSObject {
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
            weatherRepository.fetchData(latitude: latitude, longitude: longitude) { result in
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
    
    func timezoneToHourlyTime(timestamp: Int) -> String {
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
