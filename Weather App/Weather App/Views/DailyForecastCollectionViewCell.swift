//
//  DailyForecastCollectionViewCell.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/01.
//

import UIKit
import SwiftyGif

class DailyForecastCollectionViewCell: UICollectionViewCell, SwiftyGifDelegate {
    
    @IBOutlet weak var dailyWeatherDateLabel: UILabel!
    @IBOutlet weak var dailyWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var dailyWeatherMaxTemperatureLabel: UILabel!
    @IBOutlet weak var dailyWeatherMinTemperatureLabel: UILabel!
    @IBOutlet weak var dailyWeatherIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dailyWeatherIconImageView.delegate = self
    }

}
