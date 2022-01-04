//
//  SearchTableViewController.swift
//  VaccinationCenterMapApp
//
//  Created by 황신택 on 2021/11/30.
//

import UIKit
import Moya
import MapKit

class SearchTableViewController: UITableViewController {
    var handleMapSearchDelegate: HandleMapSearch? = nil
    var mapView: MKMapView!
    var list = [Center.CenterList]()
    var filteredItems = [Center.CenterList]()
    var isSearching = false
    var provider = MoyaProvider<VaccinationCenterService>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCenterData()
    }
    
    
    func getCenterData() {
        provider.request(.center(VaccinationCenterService.Param(page: 1, perPage: 284))) { result in
            switch result {
            case .success(let response):
                let decoded = try! JSONDecoder().decode(Center.self, from: response.data)
                self.list = decoded.data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredItems.count
        } else {
            return list.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if isSearching {
            let filteredItems = filteredItems[indexPath.row]
            cell.textLabel?.text = filteredItems.centerName
            let address =  "\(filteredItems.sido) \(filteredItems.sigungu)"
            cell.detailTextLabel?.text = address
            return cell
        } else {
            let selectedItem = list[indexPath.row]
            cell.textLabel?.text = selectedItem.centerName
            let address =  "\(selectedItem.sido) \(selectedItem.sigungu)"
            cell.detailTextLabel?.text = address
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
           let searchedItem = filteredItems[indexPath.row]
            handleMapSearchDelegate?.storeSearchText = searchedItem.centerName
            handleMapSearchDelegate?.dropPinZoomIn(placemark: searchedItem)
            dismiss(animated: true, completion: nil)
        } else {
            let selectedItem = list[indexPath.row]
            handleMapSearchDelegate?.storeSearchText = selectedItem.centerName
            handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
            dismiss(animated: true, completion: nil)
        }
    }
}


extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        isSearching = true
        
        filteredItems = list.filter { $0.sigungu.hasPrefix(searchBarText) || $0.sido.hasPrefix(searchBarText) }
        
        tableView.reloadData()
    }
}


