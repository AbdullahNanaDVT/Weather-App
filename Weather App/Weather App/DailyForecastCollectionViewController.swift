//
//  DailyForecastCollectionViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/01.
//

import UIKit

private let reuseIdentifier = "Cell"

class DailyForecastCollectionViewController: UICollectionViewController {
    
    private var weatherViewModel = WeatherViewModel()
    
    private var dailyWeather = WeatherResults(conditionId: 0, cityName: "", temparature: 0,
                                               timezone_offset: 0, timezone: "", current: nil, daily: nil, hourly: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.delegate = self
        weatherViewModel.weather()
        weatherViewModel.locationSetup()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "DailyForecastCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "DailyForecastCollectionViewCell")
        collectionView.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionView.reloadData()
        return dailyWeather.daily?.count ?? 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyForecastCollectionViewCell",
                                                      for: indexPath) as? DailyForecastCollectionViewCell
        
        let day = dailyWeather.daily?[indexPath.row]
        
        cell?.dateLabel.text = String(day?.dt ?? 0)
        cell?.descriptionLabel.text = day?.weather[0].description
        cell?.iconImageView.image = UIImage(systemName: weatherViewModel.icon(conditionID: day?.weather[0].id ?? 0))
        cell?.minTemperatureLabel.text = String(day?.temp.min ?? 0.0)
        cell?.maxTemperatureLabel.text = String(day?.temp.max ?? 0.0)
        
        return cell!
    }

}

extension DailyForecastCollectionViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherViewModel, weather: WeatherResults) {
        
        DispatchQueue.main.async {
            self.dailyWeather = weather
            self.collectionView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
