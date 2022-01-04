//
//  DetailTableViewCell.swift
//  VaccinationCenterMapApp
//
//  Created by 황신택 on 2021/11/25.
//

import UIKit
import CoreLocation

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var centerNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    var locationManager = LocationManager.shared.locationManager
    
    func configure(with model: CellData) {
        centerNameLabel.text = model.centerName
        
        let coordi = locationManager.location!.coordinate
        let myLocation = CLLocation(latitude: coordi.latitude, longitude: coordi.longitude)
        let destination = CLLocation(latitude: model.lat, longitude: model.long)
        let distance = myLocation.distance(from: destination) / 1000
        distanceLabel.text = "\(String(format: "%.02f", distance))km"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

}


extension DetailTableViewCell: CLLocationManagerDelegate {
    
}
