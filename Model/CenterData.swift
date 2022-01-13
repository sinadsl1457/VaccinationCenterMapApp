//
//  CenterData.swift
//  VaccinationCenterMapApp
//
//  Created by 황신택 on 2021/11/20.
//

import Foundation
import CoreLocation

/// Api Json Structure
struct Center: Codable {
    struct CenterList: Codable {
        let address: String
        let centerName: String
        let centerType: String
        let createdAt: String
        let facilityName:String
        let id: Int
        let lat: String
        let lng: String
        let org: String
        let phoneNumber: String
        let sido: String
        let sigungu: String
        let updatedAt: String
        let zipCode: String
        
        var location: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: Double(lat) ?? 0, longitude: Double(lng) ?? 0)
        }
    }
    
    let currentCount: Int
    let matchCount: Int
    let page: Int
    let perPage: Int
    let totalCount: Int
    
    let data: [CenterList]
}


