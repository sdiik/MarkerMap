//
//  CheckPoint.swift
//  MarkerMapStoryboard
//
//  Created by ahmad shiddiq on 08/04/21.
//

import SwiftUI
import MapKit

class CheckPoint: NSObject, MKAnnotation {
    var title: String?
    var subTitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?,
                  subTitle: String?,
                  coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subTitle = subTitle
        self.coordinate = coordinate
    }
    
    static func requestPointData() -> [CheckPoint] {
        return [
            CheckPoint(title: "Malang",
                       subTitle: "Malang in city in east java",
                       coordinate: .init(latitude: -7.983908, longitude: 112.621391)),
            CheckPoint(title: "Bali",
                       subTitle: "Bali in provinsi indonesia",
                       coordinate: .init(latitude: -8.739184, longitude: 115.171127))
        ]
    }
}
