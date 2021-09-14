//
//  HourlyForecastTableViewCell.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/01.
//

import UIKit
import SwiftyGif

final class HourlyForecastTableViewCell: UITableViewCell, SwiftyGifDelegate {

    @IBOutlet weak var hourlyWeatherTimeLabel: UILabel!
    @IBOutlet weak var hourlyWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var hourlyWeatherTemperatureLabel: UILabel!
    @IBOutlet weak var hourlyWeatherIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hourlyWeatherIconImageView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
