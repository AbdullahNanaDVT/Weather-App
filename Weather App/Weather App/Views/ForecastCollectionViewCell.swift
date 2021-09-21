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
    func configure(with day: Daily?) {
        do {
            let gif = try UIImage(gifName: weatherViewModel.conditionIDToIconString(id: day?.weather.first?.id ?? 0))
            forecastIconImageView.setGifImage(gif)
        } catch {
            print(error)
        }
        
        forecastDateLabel.text = weatherViewModel.timezoneToDate(timestamp: day?.dt ?? 0)
        forecastDescriptionLabel.text = day?.weather.first?.description.capitalized ?? ""
        forecastTemperatureLabel.text = String(Int(day?.temp.day ?? 0)) + "°C"
    }
    
    func configure(with hour: Hourly?) {
        do {
            let gif = try UIImage(gifName: weatherViewModel.conditionIDToIconString(id: hour?.weather.first?.id ?? 0))
            forecastIconImageView.setGifImage(gif)
        } catch {
            print(error)
        }
        
        forecastDateLabel.text = weatherViewModel.timezoneToDate(timestamp: hour?.dt ?? 0)
        forecastDescriptionLabel.text = hour?.weather.first?.description.capitalized ?? ""
        forecastTemperatureLabel.text = String(Int(hour?.temp ?? 0)) + "°C"
    }
}
