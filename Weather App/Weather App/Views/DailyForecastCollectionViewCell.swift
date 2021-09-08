//
//  DailyForecastCollectionViewCell.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/01.
//

import UIKit
import SwiftyGif

class DailyForecastCollectionViewCell: UICollectionViewCell, SwiftyGifDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.delegate = self
    }

}
