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
        collectionView.backgroundView = UIImageView(image: UIImage(named: "sunset"))
        
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
        cell?.iconImageView.image = UIImage(systemName: weatherViewModel.iconConverter(id: day?.weather[0].id ?? 0))
        cell?.minTemperatureLabel.text = String(Int(day?.temp.max ?? 0)) + "°C"
        cell?.maxTemperatureLabel.text = String(Int(day?.temp.min ?? 0)) + "°C"
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 300
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 200
    }
    
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
        print(error ?? NSError())
    }
}
