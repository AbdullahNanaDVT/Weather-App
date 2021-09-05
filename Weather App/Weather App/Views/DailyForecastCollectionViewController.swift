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
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherViewModel.numberOfDailyResults
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyForecastCollectionViewCell",
//                                                      for: indexPath) as? DailyForecastCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as? DailyForecastCollectionViewCell
        
        let day = weatherViewModel.dailyWeather?[indexPath.row]

        cell?.dateLabel.text = weatherViewModel.getDate(timestamp: day?.dt ?? 0)
        cell?.descriptionLabel.text = day?.weather[0].description.capitalized
        //cell?.iconImageView.image = UIImage(systemName: weatherViewModel.icon) //UIImage(named: weatherViewModel.icon ?? "01d")
        cell?.iconImageView.image = UIImage(named: day?.weather[0].icon ?? "01d")
        cell?.minTemperatureLabel.text = String(day?.temp.max ?? 0) + "°C"
        cell?.maxTemperatureLabel.text = String(day?.temp.min ?? 0) + "°C"
        
        return cell!
    }
    
    
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
////    {
////        return CGSize(width: 70, height: 100)
////    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let width = collectionView.frame.width / 3 - 1
//        return CGSize(width: width, height: 100)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 1.0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 1.0
//    }
    
    private func updateWeather() {
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
    
    func didFailWithError(error: NSError?) {
        print(error)
    }
}
