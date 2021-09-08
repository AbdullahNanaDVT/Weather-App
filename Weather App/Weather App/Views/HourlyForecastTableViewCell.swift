//
//  HourlyForecastTableViewCell.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/01.
//

import UIKit
import SwiftyGif

class HourlyForecastTableViewCell: UITableViewCell, SwiftyGifDelegate {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
