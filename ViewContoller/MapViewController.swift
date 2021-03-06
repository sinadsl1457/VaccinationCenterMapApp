//
//  MapViewController.swift
//  VaccinationCenterMapApp
//
//  Created by 황신택 on 2021/11/20.
//

import UIKit
import CoreLocation
import MapKit
import Moya


/// For passing from searchviewcontroller cell data.
protocol HandleMapSearch {
    var storeSearchText: String? { get set }
    func dropPinZoomIn(placemark: Center.CenterList)
}

class MapViewController: UIViewController, HandleMapSearch {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocationView: UIView!
    
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    var storeSearchText: String?
    var list = [Center.CenterList]()
    var provider = MoyaProvider<VaccinationCenterService>()
    var locationManager = LocationManager.shared.locationManager
   
    
    
    /// Make move to current location
    /// - Parameter sender: UIbutton
    @IBAction func goToCurrentLocation(_ sender: Any) {
        let locValue: CLLocationCoordinate2D = locationManager.location!.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make UISearchController Functionality
        // Integrate MapViewController
        guard let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as? SearchTableViewController else { return }
        resultSearchController = UISearchController(searchResultsController: searchVC)
        resultSearchController?.searchResultsUpdater = searchVC
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "예방접종 센터를 검색하세요."
        
        if let storeSearchText = storeSearchText {
            searchBar.text = storeSearchText
        }
        
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        searchVC.mapView = mapView
        
        getCenterData()
        mapView.register(MKMarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: NSStringFromClass(CenterAnnotaion.self))
        searchVC.handleMapSearchDelegate = self
        locationManager.delegate = self
        mapView.delegate = self
        currentLocationView.layer.cornerRadius = currentLocationView.frame.width / 2.0
        currentLocationView.clipsToBounds = true
        currentLocationView.contentMode = .scaleAspectFill
        
        // Process the status according to user permission.
        if CLLocationManager.locationServicesEnabled() {
            let status: CLAuthorizationStatus
            
            if #available(iOS 14.0, *) {
                status = locationManager.authorizationStatus
            } else {
                status = CLLocationManager.authorizationStatus()
            }
            
            switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                // 경고창
                break
            case .denied:
                // 경고창
                break
            case .authorizedAlways, .authorizedWhenInUse:
                updateLocation()
            case .authorized:
                break
            @unknown default:
                fatalError()
            }
        }
        
    }
    
    
    //MARK: Helper Method
    
    /// Setup annotation
    /// - Returns: Using given type, property return MKAnnotationView
    private func setupPlaceAnnotationView<AnnotationType: CenterAnnotaion>(for annotation:
                                                                           AnnotationType,
                                                                        on mapView: MKMapView,
                                                                           tintColor: UIColor,
                                                                           image: UIImage? = nil) -> MKAnnotationView {
        let identifier = NSStringFromClass(CenterAnnotaion.self)
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier,
                                                         for: annotation)
        
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.canShowCallout = true
            markerAnnotationView.markerTintColor = tintColor
            markerAnnotationView.glyphImage = image
            
            let rightButton = UIButton(type: .detailDisclosure)
            markerAnnotationView.rightCalloutAccessoryView = rightButton
        }
        return view
    }
    
    
    
    /// Using provider property save to list variable decoding data
    func getCenterData() {
        provider.request(.center(VaccinationCenterService.Param(page: 1, perPage: 284))) { result in
            switch result {
            case .success(let response):
                let decoded = try! JSONDecoder().decode(Center.self, from: response.data)
                self.list = decoded.data
                self.addAnnotation(model: self.list)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    /// Given decoding data do mapping to CenterAnnotaion
    func addAnnotation(model: [Center.CenterList]) {
        let annotations: [CenterAnnotaion] = model.map {
            let location = CLLocationCoordinate2D(latitude: Double($0.lat) ?? 0, longitude: Double($0.lng) ?? 0)
            return CenterAnnotaion(coordinate: location, id: $0.id, title: $0.centerName, subtitle: $0.facilityName, hospitalName: $0.org)
        }
        
        mapView.addAnnotations(annotations)
    }
}



extension MapViewController: MKMapViewDelegate {
    /// when user didtap annotation present with the same id detailVC
    /// - Parameters:
    ///   - mapView: current mapview
    ///   - view: annotation
    ///   - control:annotation's uicontrol
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let anno = view.annotation as? CenterAnnotaion {
            if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
                detailVC.center = list.first(where: { $0.id == anno.id })
                if #available(iOS 15.0, *) {
                    detailVC.sheetPresentationController?.detents = [.medium(), .large()]
                }
                self.present(detailVC, animated: true, completion: nil)
            }
        }
    }
    
    
    
    /// Can make custom annotation
    /// - Parameters:
    ///   - mapView: mapView
    ///   - annotation: mkAnnotation
    /// - Returns: annotationView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView: MKAnnotationView?
        
        if let centerAnno = annotation as? CenterAnnotaion {
            let tintColor = UIColor.systemRed
            let image = UIImage(named: "medical")
            annotationView = setupPlaceAnnotationView(for: centerAnno, on: mapView, tintColor: tintColor, image: image)
        }
        return annotationView
    }
}


extension MapViewController: CLLocationManagerDelegate {
    func updateLocation() {
        locationManager.startUpdatingLocation()
    }
    
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            updateLocation()
        default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            updateLocation()
        default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
    
    
    
    /// when user launch app right away showing current user location zoom in.
    /// - Parameters:
    ///   - manager: _
    ///   - locations: _
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = locationManager.location!.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        
        mapView.setRegion(region, animated: true)
    }
}


extension MapViewController {
    
    /// when user searched cell didtap and then given center data make new annotation and add mapView.
    /// Apointing use animation zoom in specific annotation(Center)
    /// - Parameter placemark: Center.CenterList from searchViewcontroller.
    func dropPinZoomIn(placemark: Center.CenterList) {
        let coordinate = CLLocationCoordinate2D(latitude: Double(placemark.lat) ?? 0, longitude: Double(placemark.lng) ?? 0)
        
        let annotation: CenterAnnotaion = CenterAnnotaion(coordinate: coordinate, id: placemark.id, title: placemark.centerName, subtitle: placemark.address, hospitalName: placemark.org)
        
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
