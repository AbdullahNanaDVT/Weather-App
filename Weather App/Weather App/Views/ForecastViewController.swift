//
//  ForecastViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/15.
//

import UIKit

class ForecastViewController: UIViewController {
    private lazy var weatherViewModel = ForecastViewModel()
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var forecastSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        applyCollectionViewStyling()
        updateWeather()
    }
    
    private func updateWeather() {
        weatherViewModel.loadWeatherData { _ in
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func didTapForecastSwitch(_ sender: Any) {
        collectionView.reloadData()
    }
    
    private func applyCollectionViewStyling() {
        collectionView.backgroundView = UIImageView(image: UIImage(named: "test"))
    }
}

extension ForecastViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecastSwitch.isOn ? weatherViewModel.dailyWeatherResultsCount : weatherViewModel.hourlyWeatherResultsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell",
                                                      for: indexPath as IndexPath) as? ForecastCollectionViewCell
        
        if forecastSwitch.isOn {
            guard let day = weatherViewModel.dailylyWeather(at: indexPath.row) else {return UICollectionViewCell()}
            cell?.configure(day: day, hour: nil, weatherType: .daily)

        } else {
            guard let hour = weatherViewModel.hourlyWeather(at: indexPath.row) else {return UICollectionViewCell()}
            cell?.configure(day: nil, hour: hour, weatherType: .hourly)
        }
        
        cell?.layer.borderColor = UIColor.white.cgColor
        cell?.layer.borderWidth = 5
        cell?.backgroundColor = .clear
        
        return cell!
    }
}

extension ForecastViewController: WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherResults) {
        DispatchQueue.main.async {
            self.updateWeather()
        }
    }
    
    func didFailWithError(error: NSError?) {
        print(error ?? NSError())
    }
}
