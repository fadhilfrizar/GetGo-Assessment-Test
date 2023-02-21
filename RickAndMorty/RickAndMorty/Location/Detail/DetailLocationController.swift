//
//  DetailLocationController.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 21/02/23.
//

import UIKit

class DetailLocationController: UIViewController {

    var locations: LocationResult?
    
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
        guard let data = locations else { return }
        
        self.navigationItem.title = data.name
        self.detailNameLabel.text = data.name
        self.detailCreatedLabel.text = data.created.convertStringToDateString()
        self.detailTypeLabel.text = "Type: \(data.type)"
        self.detailDimensionLabel.text = data.dimension
        self.detailResidentsLabel.text = "\(data.residents.joined(separator: "\n"))"
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
