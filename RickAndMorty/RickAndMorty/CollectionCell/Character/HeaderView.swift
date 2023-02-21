//
//  HeaderView.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 20/02/23.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    public let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    public func configure() {
        backgroundColor = .white
        addSubview(label)
    }
    
    override func layoutSubviews() {
        
        label.frame = CGRect(x: 8, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
}
