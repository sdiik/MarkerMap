//
//  MapScreenAdvanceStruct.swift
//  MarkerMapStoryboard
//
//  Created by ahmad shiddiq on 08/04/21.
//

import SwiftUI
import MapKit

struct MapScreenAdvanceStruct: UIViewRepresentable {
    let landmarks = CheckPoint.requestPointData()
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.delegate = context.coordinator
        uiView.addAnnotations(landmarks)
    }
    
}

struct MapScreenAdvanceStruct_Previews: PreviewProvider {
    static var previews: some View {
        MapScreenAdvanceStruct()
    }
}
