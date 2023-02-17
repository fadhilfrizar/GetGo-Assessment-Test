//
//  Character.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

struct CharacterModel: Codable {
    let info: InfoModel
    let result: [CharacterResult]
}

struct CharacterResult: Codable {
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

struct CharacterResultOriginAndLocation: Codable {
    let name: String
    let url: String
    
}
