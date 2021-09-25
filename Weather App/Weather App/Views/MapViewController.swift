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
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
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
        //mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
        let annotations = MKPointAnnotation()
        updateWeather()
        annotations.title = viewModel.currentLocationCityName
        annotations.subtitle = viewModel.currentLocationTemparature + "°C"
        annotations.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(annotations)
        
        let locations = [
            ["title": "New York, NY",    "latitude": 40.713054, "longitude": -74.007228],
            ["title": "Los Angeles, CA", "latitude": 34.052238, "longitude": -118.243344],
            ["title": "Chicago, IL",     "latitude": 41.883229, "longitude": -87.632398]
        ]
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.title = location["title"] as? String
            annotation.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as? Double ?? 0.0, longitude: location["longitude"] as? Double ?? 0.0)
            mapView.addAnnotation(annotation)
        }
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
