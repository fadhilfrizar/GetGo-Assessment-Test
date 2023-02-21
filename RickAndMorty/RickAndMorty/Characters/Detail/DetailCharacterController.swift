//
//  DetailCharacterController.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 18/02/23.
//

import UIKit

class DetailCharacterController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView! {
        didSet {
            detailImageView.clipsToBounds = true
            detailImageView.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailStatusLabel: UILabel!
    @IBOutlet weak var detailGenderLabel: UILabel!
    
    @IBOutlet weak var detailSpeciesLabel: UILabel!
    
    @IBOutlet weak var detailCreatedLabel: UILabel!
    @IBOutlet weak var detailOriginLabel: UILabel!
    @IBOutlet weak var detailLocationLabel: UILabel!
    @IBOutlet weak var detailEpisodeLabel: UILabel!
    
    var characters: CharacterResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    private func initView() {
        guard let data = characters else { return }
        
        self.navigationItem.title = data.name
        
        self.detailImageView.loadImageUsingCacheWithUrlString(data.image)
        
        self.detailNameLabel.text = data.name
        self.detailStatusLabel.text = "Status: \(data.status)"
        self.detailGenderLabel.text = "Gender: \(data.gender)"
        self.detailSpeciesLabel.text = "Species: \(data.species)"
        
        self.detailCreatedLabel.text = data.created.convertStringToDateString()
        
        self.detailOriginLabel.text = data.origin.name
        self.detailLocationLabel.text = data.location.name
        
        self.detailEpisodeLabel.text = "\(data.episode.joined(separator: "\n"))"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
