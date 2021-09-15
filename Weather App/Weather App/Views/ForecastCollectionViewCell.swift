//
//  ForecastCollectionViewCell.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/15.
//

import UIKit
import SwiftyGif

class ForecastCollectionViewCell: UICollectionViewCell, SwiftyGifDelegate {
    @IBOutlet weak var forecastDateLabel: UILabel!
    @IBOutlet weak var forecastIconImageView: UIImageView!
    @IBOutlet weak var forecastDescriptionLabel: UILabel!
    @IBOutlet weak var forecastTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        forecastIconImageView.delegate = self
    }
}
