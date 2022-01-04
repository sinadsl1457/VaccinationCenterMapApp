//
//  LocationManager.swift
//  VaccinationCenterMapApp
//
//  Created by 황신택 on 2022/01/04.
//

import Foundation
import CoreLocation

class LocationManager {
    static let shared = LocationManager()
    private init() { }
        
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = CLLocationDistance(100)
        return manager
    }()
}

