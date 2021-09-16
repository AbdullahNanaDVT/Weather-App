//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/29.
//

import Foundation
import CoreLocation

final class WeatherRepository: NSObject {
    private lazy var weatherResults = WeatherResults(weather: nil)
    static let shared = WeatherRepository()
    
    override init() {
        super.init()
    }
    
    private let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?&units=metric&exclude=minutely"
    
    func weatherData(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler: @escaping (Result<WeatherResults, Error>) -> Void) {
        
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)&appid=\(Constants.APIKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let data = data else { return }
            
            do {
                let decodedWeatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                let currentWeather = WeatherResults(weather: decodedWeatherData)
                completionHandler(.success(currentWeather))
                
            } catch let error as NSError {
                completionHandler(.failure(error))
            }
            
        }.resume()
    }
}
