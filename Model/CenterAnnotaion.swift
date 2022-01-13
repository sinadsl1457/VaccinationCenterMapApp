//
//  CenterAnnotaion.swift
//  VaccinationCenterMapApp
//
//  Created by 황신택 on 2021/11/22.
//

import Foundation
import MapKit

/// Make for Map Annotation Passing Api Data.
class CenterAnnotaion: NSObject, MKAnnotation {
     init(coordinate: CLLocationCoordinate2D, id: Int, title: String? = nil, subtitle: String? = nil, hospitalName: String) {
        self.coordinate = coordinate
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.hospitalName = hospitalName
    }
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    let id: Int
    let title: String?
    let subtitle: String?
    let hospitalName: String
}
