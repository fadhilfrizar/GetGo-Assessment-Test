//
//  EpisodeCollectionCell.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import UIKit

class EpisodeCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }

}

extension EpisodeCell {
    func configure(_ vm: EpisodeItemViewModel) {
        self.nameLabel.text = vm.name
        self.seasonLabel.text = vm.season
        self.episodeLabel.text = vm.episodes
        self.airDateLabel.text = "Air date: \n\(vm.air_date)"
    }
}
