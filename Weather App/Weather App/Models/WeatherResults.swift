//
//  WeatherModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/29.
//

import Foundation

struct WeatherResults {
    let weather: WeatherData?
    
    var hourlyWeather: [Hourly]? {
        weather?.hourly
    }
    
    var currentWeather: Current? {
        weather?.current
    }
    
    var dailyWeather: [Daily]? {
        weather?.daily
    }
    
    var timezone: String {
        weather?.timezone ?? ""
    }
    
    var timezoneOffset: Int {
        weather?.timezone_offset ?? 0
    }
    
    func conditionIDToIconString(conditionID: Int) -> String {
        switch conditionID {
        case 200...232:
            return "thunderstorm.gif"
        case 300...321:
            return "rain.gif"
        case 500...531:
            return "rain.gif"
        case 600...622:
            return "snow.gif"
        case 700...781:
            return "cloud.gif"
        case 800:
            return "sun.gif"
        case 801...804:
            return "cloud.gif"
        default:
            return "cloud.gif"
        }
    }
}
