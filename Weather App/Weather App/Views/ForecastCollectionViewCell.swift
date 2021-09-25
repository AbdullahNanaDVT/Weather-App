//
//  ForecastCollectionViewCell.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/15.
//

import UIKit
import SwiftyGif

class ForecastCollectionViewCell: UICollectionViewCell, SwiftyGifDelegate {
    @IBOutlet private weak var forecastDateLabel: UILabel!
    @IBOutlet private weak var forecastIconImageView: UIImageView!
    @IBOutlet private weak var forecastDescriptionLabel: UILabel!
    @IBOutlet private weak var forecastTemperatureLabel: UILabel!
    private lazy var weatherViewModel = ForecastViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        forecastIconImageView.delegate = self
    }
}

extension ForecastCollectionViewCell {
    func configure(day: Daily? = nil, hour: Hourly? = nil, weatherType: WeatherType) {
        
        var conditionIDToString = ""
        var forecastDate = ""
        var forecastDescription = ""
        var forecastTemperature = ""
        
        if weatherType == .daily {
            conditionIDToString = weatherViewModel.iconNameFromConditionID(id: day?.weather.first?.id ?? 0)
            forecastDate = weatherViewModel.timezoneToDate(timestamp: day?.dt ?? 0)
            forecastDescription = day?.weather.first?.description.capitalized ?? ""
            forecastTemperature = String(Int(day?.temp.day ?? 0))
            
        } else {
            conditionIDToString = weatherViewModel.iconNameFromConditionID(id: hour?.weather.first?.id ?? 0)
            forecastDate = weatherViewModel.timezoneToHourlyTime(timestamp: hour?.dt ?? 0)
            forecastDescription = hour?.weather.first?.description.capitalized ?? ""
            forecastTemperature = String(Int(hour?.temp ?? 0))
        }
        
        do {
            let gif = try UIImage(gifName: conditionIDToString)
            forecastIconImageView.setGifImage(gif)
        } catch {
            print(error)
        }
        
        forecastDateLabel.text = forecastDate
        forecastDescriptionLabel.text = forecastDescription
        forecastTemperatureLabel.text = forecastTemperature + "°C"
    }
}

extension ForecastCollectionViewCell {
    enum WeatherType {
        case hourly
        case daily
    }
}
