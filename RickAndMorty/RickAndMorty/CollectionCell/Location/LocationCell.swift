//
//  LocationCell.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import UIKit

class LocationCell: UICollectionViewCell {

    @IBOutlet weak var dimensionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }

}

extension LocationCell {
    func configure(_ vm: LocationItemViewModel) {
        self.nameLabel.text = vm.name
        self.typeLabel.text = vm.planet
        self.dimensionLabel.text = "Dimension : \n\(vm.dimension)"
    }
}
