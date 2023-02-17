//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    
    @IBOutlet weak var characterImageView: UIImageView! {
        didSet {
            self.characterImageView.clipsToBounds = true
            self.characterImageView.layer.cornerRadius = 12
            self.characterImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    @IBOutlet weak var characterSpeciesLabel: UILabel!
    @IBOutlet weak var characterNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
    }

}

extension CharacterCell {
    func configure(_ vm: CharactersItemViewModel) {
        self.characterNameLabel.text = vm.name
        self.characterSpeciesLabel.text = vm.species
        self.characterImageView.loadImageUsingCacheWithUrlString(vm.image)
    }
}
