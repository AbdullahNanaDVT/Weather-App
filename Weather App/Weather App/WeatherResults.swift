//
//  WeatherModel.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/08/29.
//

import Foundation

struct WeatherResults {
    let conditionId: Int
    let cityName: String
    let temparature: Double

    let weather: WeatherData

    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }

    var temparatureString: String {
        return String(format: "%.1f", temparature)
    }
}
