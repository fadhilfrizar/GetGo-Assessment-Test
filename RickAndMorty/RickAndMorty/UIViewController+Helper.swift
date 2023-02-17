//
//  UIViewController+Helper.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 17/02/23.
//

import Foundation
import UIKit

extension UIViewController {
    func handle(_ error: Error, completion: @escaping () -> ()) {
        let alert = UIAlertController(
            title: "An error occured",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "Dismiss",
            style: .default
        ))
        
        alert.addAction(UIAlertAction(
            title: "Retry",
            style: .default,
            handler: { _ in
                completion()
            }
        ))
        
        present(alert, animated: true)
    }
}

