//
//  MapViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/16.
//

import UIKit
import MapKit

class WeatherMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    private lazy var locationManager = CLLocationManager()
    private lazy var weatherViewModel = WeatherMapViewModel()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!
    private var locations: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        showLocation()
        showCurrentLocation()
        
        addButton.titleLabel?.text = ""
    }
    
    private func updateWeather() {
        weatherViewModel.loadWeatherData { _ in
            self.showCurrentLocation()
        }
    }
    
    @IBAction private func didTapAddButton(_ sender: Any) {
        addButton.titleLabel?.text = ""
        var locationTextField = UITextField()
        
        let alert = UIAlertController(title: weatherViewModel.locationTitle,
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { textField in
            locationTextField = textField
        }
        
        let action = UIAlertAction(title: weatherViewModel.addLocationButtonTitle, style: .default) { _ in
            self.locations.append(locationTextField.text ?? "")
            self.updateWeather(cityName: locationTextField.text ?? "Johannesburg")
            self.updateWeather(cityName: locationTextField.text ?? "Johannesburg")
            self.showLocation()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func updateWeather(cityName: String) {
        weatherViewModel.loadWeatherData(cityName: cityName) { _ in
            DispatchQueue.main.async { [self] in
                self.showLocation()
            }
        }
    }
    
    private func showLocation() {
        for location in locations {
            let annotations = MKPointAnnotation()
            updateWeather(cityName: location)
            annotations.title = location
            annotations.subtitle = weatherViewModel.currentLocationTemparature + "°C"
            weatherViewModel.coordinate(addressString: location) { locationCoordinates, _ in
                annotations.coordinate = locationCoordinates
            }
            mapView.addAnnotation(annotations)
        }
    }
    
    private func showCurrentLocation() {
        guard let latitude = locationManager.location?.coordinate.latitude else { return }
        guard let longitude = locationManager.location?.coordinate.longitude else { return }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let annotation = MKPointAnnotation()
        updateWeather()
        annotation.title = weatherViewModel.currentLocationCityName
        annotation.subtitle = weatherViewModel.currentLocationTemparature + "°C"
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}
