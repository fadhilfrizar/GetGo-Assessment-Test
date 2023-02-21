//
//  FilterViewController.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 20/02/23.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            collectionView.register(UINib(nibName: "FilterCell", bundle: nil), forCellWithReuseIdentifier: "filterCell")
            collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerReusableView")
            
            collectionView.allowsMultipleSelection = true
            
        }
    }
    
    var status = ["Alive", "Dead", "Unknown"]
    var species = ["Alien", "Animal", "Mythological Creature", "Human"]
    var gender = ["Male", "Female", "Genderless", "Unknown"]
    
    var selectedStatus: String = ""
    var selectedSpecies: String = ""
    var selectedGender: String = ""
    
    var delegate: ReceivedFilterData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func applyButton(_ sender: UIButton) {
        sender.clipsToBounds = true
        sender.layer.cornerRadius = 12
        
        print("Select Status = ", selectedStatus)
        print("Select Species = ", selectedSpecies)
        print("Select Gender = ", selectedGender)
        
        self.dismiss(animated: true) {
            var arrayData: [String] = []
            arrayData.append(self.selectedStatus)
            arrayData.append(self.selectedSpecies)
            arrayData.append(self.selectedGender)
            
            self.delegate?.filterData(data: arrayData)
        }
    }
    
}


extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerReusableView", for: indexPath) as! HeaderView
        
        switch indexPath.section {
        case 0:
            header.label.text = "Status"
        case 1:
            header.label.text = "Species"
        case 2:
            header.label.text = "Gender"
        default:
            break
        }
        header.configure()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return status.count
        case 1:
            return species.count
        case 2:
            return gender.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
            
            cell.filterLabel.text = status[indexPath.row]
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
            
            cell.filterLabel.text = species[indexPath.row]
            
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
            
            cell.filterLabel.text = gender[indexPath.row]
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch indexPath.section {
        case 0:
            self.selectedStatus = self.status[indexPath.row]
        case 1:
            self.selectedSpecies = self.species[indexPath.row]
        case 2:
            self.selectedGender = self.gender[indexPath.row]
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            let heights = 40
            let text = self.status[indexPath.row]
            let widths = text.width(withConstrainedHeight: CGFloat(heights), font: UIFont.systemFont(ofSize: 16))
            
            return CGSize(width: widths + 16, height: 40)
        case 1:
            let heights = 40
            let text = self.species[indexPath.row]
            let widths = text.width(withConstrainedHeight: CGFloat(heights), font: UIFont.systemFont(ofSize: 16))
            
            return CGSize(width: widths + 16, height: 40)
        case 2:
            let heights = 40
            let text = self.gender[indexPath.row]
            let widths = text.width(withConstrainedHeight: CGFloat(heights), font: UIFont.systemFont(ofSize: 16))
            
            return CGSize(width: widths + 16, height: 40)
        default:
            return CGSize.zero
        }
    }
    
    
}

extension String {
    
    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
