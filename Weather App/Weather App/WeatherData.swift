//
//  WeatherData.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/29.
//

import Foundation

struct Current: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
}

struct Hourly: Codable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let clouds: Int
    let pop: Double
    let weather: [Weather]
}

struct Daily: Codable {
    let dt: Int
    let temp: Temp
    let clouds: Int
    let humidity: Int
    let pop: Double
    let weather: [Weather]
    
    struct Temp: Codable {
        let min: Double
        let max: Double
    }
}

struct Weather: Codable {
    let id: Int
    let description: String
    let icon: String
}


struct WeatherDataModel: Codable {
    let timezone: String
    let current: Current
    let daily: [Daily]
    let hourly: [Hourly]
}
