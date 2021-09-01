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

    let timezone_offset: Int
    let timezone: String
    let current: Current?
    let daily: [Daily]?
    let hourly: [Hourly]?

    var temparatureString: String {
        return String(format: "%.1f", temparature)
    }
}
