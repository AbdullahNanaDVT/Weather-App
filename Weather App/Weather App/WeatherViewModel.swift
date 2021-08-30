//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/29.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManager: WeatherViewModel, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherViewModel {
    let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?lat=51.5085&lon=-0.1257&appid=a23b6e0a5d268dcbe83c49431ec99def&units=metric&exclude=minutely"
    
    weak var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherDataModel.self, from: weatherData)
            let current = decodedData.current
            let daily = decodedData.daily
            let hourly = decodedData.hourly
            
            let id = decodedData.current.weather[0].id
            let temp = decodedData.current.temp
            let name = decodedData.timezone
            
            let weather = WeatherModel(conditionId: id, cityName: name, temparature: temp, current: current, daily: daily, hourly: hourly)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
