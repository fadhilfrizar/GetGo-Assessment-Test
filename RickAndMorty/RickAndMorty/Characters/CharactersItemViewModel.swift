//
//  CharactersItemViewModel.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

struct CharactersItemViewModel {
    let image: String
    let name: String
    let species: String
}

extension CharactersItemViewModel {
    init(characters: CharacterResult) {
        image = characters.image
        name = characters.name
        species = characters.species
    }
}
