//
//  MapScreenStruct.swift
//  MarkerMapStoryboard
//
//  Created by ahmad shiddiq on 08/04/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var locationManager = CLLocationManager()
    
    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func makeUIView(context: Context) -> some UIView {
        setupManager()
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct MapScreenStruct: View {
    var body: some View {
        MapView()
    }
}

struct MapScreenStruct_Previews: PreviewProvider {
    static var previews: some View {
        MapScreenStruct()
    }
}
