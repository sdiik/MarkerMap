//
//  MapScreenController.swift
//  MarkerMapStoryboard
//
//  Created by ahmad shiddiq on 04/04/21.
//

import Foundation
import MapKit
import CoreLocation

class MapScreenController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionMeters: Double = 10000
    var previousLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                                 latitudinalMeters: regionMeters,
                                                 longitudinalMeters: regionMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            break
        default:
            break
        }
    }
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func getDirections() {
        guard let location = locationManager.location?.coordinate else { return }
        let request  = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else { return }
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func createDirectionsRequest(from  coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate           = getCenterLocation(for: mapView).coordinate
        let startingLocation                = MKPlacemark(coordinate: coordinate)
        let destination                     = MKPlacemark(coordinate: destinationCoordinate)
        
        let request                         = MKDirections.Request()
        request.source                      = MKMapItem(placemark: startingLocation)
        request.destination                 = MKMapItem(placemark: destination)
        request.transportType               = .automobile
        request.requestsAlternateRoutes     = true
        return request
    }
    
    @IBAction  func goButtonTapped(_ sender: UIButton) {
        getDirections()
    }
    
}

extension MapScreenController: CLLocationManagerDelegate {
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
//                                            longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center,
//                                             latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
//        mapView.setRegion(region, animated: true)
//    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapScreenController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return}
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            if let _ = error {
                //TODO: show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: show alert information the user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self?.addressLabel.text = "\(streetNumber) \(streetName)"
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer =  MKPolygonRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        return renderer
    }
}
