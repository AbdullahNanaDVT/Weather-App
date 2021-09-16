//
//  MapViewController.swift
//  Weather App
//
//  Created by Abdullah Nana on 2021/09/16.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    private lazy var locationManager = CLLocationManager()
    private lazy var viewModel = CurrentLocationViewModel()
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        map.delegate = self
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        showLocation()
    }
    
    private func updateWeather() {
        viewModel.loadWeatherData { _ in
            self.viewDidLoad()
        }
    }
    
    private func showLocation() {
        guard let latitude = locationManager.location?.coordinate.latitude else { return }
        guard let longitude = locationManager.location?.coordinate.longitude else { return }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        map.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
        let annotations = MKPointAnnotation()
        updateWeather()
        annotations.title = viewModel.currentLocationCityName
        annotations.subtitle = viewModel.currentLocationTemparature + "°C"
        annotations.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        map.addAnnotation(annotations)
    }
}

extension MapViewController {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "pin"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ??
            MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        annotationView.canShowCallout = true
        if annotation is MKUserLocation {
            return nil
        } else {
            annotationView.image =  UIImage(named: "cloud")
            return annotationView
        }
    }
}
