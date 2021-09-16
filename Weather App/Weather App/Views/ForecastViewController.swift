//
//  ForecastViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/15.
//

import UIKit
import SwiftyGif

class ForecastViewController: UIViewController {
    private lazy var weatherViewModel = ForecastViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var forecastSwitch: UISwitch!
    
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
        forecastSwitch.isOn ? weatherViewModel.numberOfDailyWeatherResults : weatherViewModel.numberOfHourlyWeatherResults
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        if forecastSwitch.isOn {
            forecastSwitch.tintColor = .blue
        } else {
            forecastSwitch.tintColor = .brown
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell",
                                                      for: indexPath as IndexPath) as? ForecastCollectionViewCell
        if forecastSwitch.isOn {
            let day = weatherViewModel.dailyWeather?[indexPath.row]
            
            do {
                let gif = try UIImage(gifName: weatherViewModel.conditionIDToIconString(id: day?.weather.first?.id ?? 0))
                cell?.forecastIconImageView.setGifImage(gif)
                
            } catch {
                print(error)
            }
            
            cell?.forecastDateLabel.text = weatherViewModel.timezoneToDate(timestamp: day?.dt ?? 0)
            cell?.forecastDescriptionLabel.text = day?.weather.first?.description.capitalized
            cell?.forecastTemperatureLabel.text = String(Int(day?.temp.day ?? 0)) + "°C"
            cell?.layer.borderColor = UIColor.white.cgColor
            cell?.layer.borderWidth = 5
            cell?.backgroundColor = .clear
            
            return cell!
        } else {
            let hour = weatherViewModel.hourlyWeather?[indexPath.row]
            
            do {
                let gif = try UIImage(gifName: weatherViewModel.conditionIDToIconString(id: hour?.weather.first?.id ?? 0))
                cell?.forecastIconImageView.setGifImage(gif)
            } catch {
                print(error)
            }
            
            cell?.forecastDateLabel.text = weatherViewModel.timezoneToHourlyTime(timestamp: hour?.dt ?? 0)
            cell?.forecastDescriptionLabel.text = hour?.weather.first?.description.capitalized
            cell?.forecastTemperatureLabel.text = String(Int(hour?.temp ?? 0)) + "°C"
            cell?.layer.borderColor = UIColor.white.cgColor
            cell?.layer.borderWidth = 5
            cell?.backgroundColor = .clear
            
            return cell!
        }
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
