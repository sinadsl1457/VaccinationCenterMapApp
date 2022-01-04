//
//  CenterMapData.swift
//  VaccinationCenterMapApp
//
//  Created by 황신택 on 2021/11/22.
//

import Foundation

class CellData {
    init(cellModel: Center.CenterList) {
        self.centerName = cellModel.centerName
        self.distance = "3km"
        self.address = cellModel.address
        self.phoneNumber = cellModel.phoneNumber
        self.locality = "\(cellModel.sigungu) \(cellModel.sido)"
        self.lat = Double(cellModel.lat) ?? 0
        self.long = Double(cellModel.lng) ?? 0
        
    }

    let centerName: String
    let distance: String
    let address: String
    let phoneNumber: String
    let locality: String
    let lat: Double
    let long: Double
}




