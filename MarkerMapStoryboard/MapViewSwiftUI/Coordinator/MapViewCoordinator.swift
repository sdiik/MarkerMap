//
//  MapViewCoordinator.swift
//  MarkerMapStoryboard
//
//  Created by ahmad shiddiq on 08/04/21.
//

import Foundation
import MapKit

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    var mapViewCoordinator: MapScreenAdvanceStruct
    
    init(_ control: MapScreenAdvanceStruct) {
        self.mapViewCoordinator = control
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customView")
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: "icon_marker")
        return annotationView
    }
}
