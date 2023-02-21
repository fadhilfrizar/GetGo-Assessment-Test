//
//  DetailEpisodeController.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 21/02/23.
//

import UIKit

class DetailEpisodeController: UIViewController {

    var episodes: EpisodeResult?
    
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailCreatedLabel: UILabel!
    @IBOutlet weak var detailTypeLabel: UILabel!
    @IBOutlet weak var detailDimensionLabel: UILabel!
    @IBOutlet weak var detailResidentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        guard let data = episodes else { return }
        
        self.navigationItem.title = data.name
        self.detailNameLabel.text = data.name
        self.detailCreatedLabel.text = data.created.convertStringToDateString()
        self.detailTypeLabel.text = "Air Date: \(data.air_date)"
        self.detailDimensionLabel.text = data.episode
        self.detailResidentsLabel.text = "\(data.characters.joined(separator: "\n"))"
    }

}
