//
//  LocationInfoTableCell.swift
//  VaccinationCenterMapApp
//
//  Created by 황신택 on 2021/11/26.
//

import UIKit

class LocationInfoTableCell: UITableViewCell {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var localityLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    func configure(with model: CellData) {
        addressLabel.text = model.address
        localityLabel.text = model.locality
        phoneNumberLabel.text = model.phoneNumber
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

