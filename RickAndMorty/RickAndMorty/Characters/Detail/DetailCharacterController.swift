//
//  DetailCharacterController.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 18/02/23.
//

import UIKit

class DetailCharacterController: UIViewController {

    var characters: CharacterResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = characters?.name ?? ""
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
