//
//  Character.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

struct CharacterResult {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterResultOriginAndLocation
    let location: CharacterResultOriginAndLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
}
extension CharacterResult: Equatable {
    static func == (lhs: CharacterResult, rhs: CharacterResult) -> Bool {
        return lhs.id == rhs.id
    }
}


struct CharacterResultOriginAndLocation: Codable {
    let name: String
    let url: String
    
}

