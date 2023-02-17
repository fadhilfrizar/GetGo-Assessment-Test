//
//  LocationItemViewModel.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

struct LocationItemViewModel {
    let name: String
    let dimension: String
    let planet: String
}

extension LocationItemViewModel {
    init(location: LocationResult) {
        name = location.name
        dimension = location.dimension
        planet = location.type
    }
}
