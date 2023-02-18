//
//  Location.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

//struct LocationModel: Codable {
//    let info: InfoModel
//    let locationResult: [LocationResult]
//}

struct LocationResult {
    
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}

extension LocationResult: Equatable {}
