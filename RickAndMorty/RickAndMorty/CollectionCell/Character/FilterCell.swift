//
//  FilterCell.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 20/02/23.
//

import UIKit

class FilterCell: UICollectionViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                //You can change this method according to your need.
                setSelected()
            }
            else {
                //You can change this method according to your need.
                setUnselected()
            }
        }
    }

    func setSelected(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.tintColor.cgColor
        self.filterLabel.textColor = UIColor.tintColor
    }
    
    func setUnselected(){
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.filterLabel.textColor = UIColor.lightGray
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.layer.frame.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.filterLabel.textColor = UIColor.lightGray
    }

}
