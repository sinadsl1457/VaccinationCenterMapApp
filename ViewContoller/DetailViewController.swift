//
//  DetailViewController.swift
//  VaccinationCenterMapApp
//
//  Created by 황신택 on 2021/11/25.
//

import UIKit
import MapKit
import CoreLocation


/// Present TableView about annotation Info
class DetailViewController: UIViewController {
    @IBOutlet weak var detailTableView: UITableView!
    
    var center: Center.CenterList?
    var cellModel: CellData!
    var mapView: MKMapView!
    var annotation: MKAnnotation!
    var locationManager = LocationManager.shared.locationManager
    
    
    /// when user didtap make go to AppleInMap
    /// - Parameter sender: UIbutton
    @IBAction func goToInMap(_ sender: Any) {
        openInMap()
    }
    
    
    /// When user didtap present apple share fuction.
    /// - Parameter sender: Uibutton
    @IBAction func share(_ sender: UIButton) {
        if let centerName = center?.centerName, let address = center?.address {
            let activityVC = UIActivityViewController(activityItems: [centerName, address], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = sender
            present(activityVC, animated: true, completion: nil)
            activityVC.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                
                if completed  {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    /// Make a phone call
    /// - Parameter sender: UIbutton
    @IBAction func makeCalling(_ sender: Any) {
        if let center = center {
            if let url = URL(string: "tel://\(center.phoneNumber)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let center = center {
            cellModel = CellData(cellModel: center)
        }
    }
    
    
    /// Calculate the location of the actual user and the location of the annotation and provide it a route.
   private func openInMap() {
        let userCoor = locationManager.location!.coordinate
        let source = MKMapItem(placemark: MKPlacemark(coordinate: userCoor))
        source.name = "Current Location"
        if let center = center {
            let destinationCoor = CLLocationCoordinate2D(latitude: Double(center.lat) ?? 0, longitude: Double(center.lng) ?? 0)
            let destinaion = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoor))
            
            destinaion.name = center.centerName
            
            MKMapItem.openMaps(with: [source, destinaion], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
}


extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
            cell.configure(with: cellModel)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationInfoTableCell", for: indexPath) as! LocationInfoTableCell
            cell.configure(with: cellModel)
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "위치정보"
        }
        return ""
    }
}


extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 150
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.detailTableView.deselectRow(at: indexPath, animated: true)
    }
}

