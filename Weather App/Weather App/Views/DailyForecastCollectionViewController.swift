//
//  DailyForecastCollectionViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/01.
//

import UIKit
import SwiftyGif

final class DailyForecastCollectionViewController: UICollectionViewController {
    private lazy var weatherViewModel = DailyForecastViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        applyCollectionViewStyling()
        updateWeather()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherViewModel.numberOfDailyResults
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as? DailyForecastCollectionViewCell
        let day = weatherViewModel.dailyWeather?[indexPath.row]
        
        do {
            let gif = try UIImage(gifName: weatherViewModel.iconConverter(id: day?.weather[0].id ?? 0))
            cell?.dailyWeatherIconImageView.setGifImage(gif)
            
        } catch {
            print(error)
        }

        cell?.dailyWeatherDateLabel.text = weatherViewModel.timezoneToDate(timestamp: day?.dt ?? 0)
        cell?.dailyWeatherDescriptionLabel.text = day?.weather[0].description.capitalized
        cell?.dailyWeatherMinTemperatureLabel.text = "Min: " + String(Int(day?.temp.max ?? 0)) + "°C"
        cell?.dailyWeatherMaxTemperatureLabel.text = "Max: " + String(Int(day?.temp.min ?? 0)) + "°C"
        cell?.layer.borderColor = UIColor.white.cgColor
        cell?.layer.borderWidth = 5
        cell?.backgroundColor = .clear
        
        return cell!
    }
    
    private func updateWeather() {
        weatherViewModel.loadWeatherData { _ in
            self.collectionView.reloadData()
        }
    }
    
    private func applyCollectionViewStyling() {
        collectionView.backgroundView = UIImageView(image: UIImage(named: "test"))
        
        self.collectionView.register(UINib(nibName: "DailyForecastCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "DailyForecastCollectionViewCell")
    }
}

extension DailyForecastCollectionViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherResults) {
        DispatchQueue.main.async {
            self.updateWeather()
        }
    }
    
    func didFailWithError(error: NSError?) {
        print(error ?? NSError())
    }
}
