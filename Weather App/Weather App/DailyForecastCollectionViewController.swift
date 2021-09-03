//
//  DailyForecastCollectionViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/01.
//

import UIKit

class DailyForecastCollectionViewController: UICollectionViewController {
    
    private var weatherViewModel = DailyForecastViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "DailyForecastCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "DailyForecastCollectionViewCell")
        updateWeather()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        weatherViewModel.dailyWeather?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyForecastCollectionViewCell",
                                                      for: indexPath) as? DailyForecastCollectionViewCell
        
        let day = weatherViewModel.dailyWeather?[indexPath.row]
        
        cell?.dateLabel.text = String(day?.dt ?? 0)
        cell?.descriptionLabel.text = day?.weather[0].description
        cell?.iconImageView.image = UIImage(named: weatherViewModel.icon ?? "01d")
        cell?.minTemperatureLabel.text = String(day?.temp.min ?? 0.0)
        cell?.maxTemperatureLabel.text = String(day?.temp.max ?? 0.0)
        
        return cell!
    }
    
    func updateWeather() {
        weatherViewModel.mapWeatherData { _ in
            self.collectionView.reloadData()
        }
    }
}

extension DailyForecastCollectionViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherResults) {
        DispatchQueue.main.async {
            self.updateWeather()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
