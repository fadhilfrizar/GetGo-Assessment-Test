//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

class CharactersViewModel {
    private let service: CharacterService
    
    init(service: CharacterService){
        self.service = service
    }
    
    typealias Observer<T> = (T) -> Void
    
    var onCharactersLoad: Observer<[CharacterResult]>?
    var onCharactersError: Observer<Error>?
    var onCharactersLoading: Observer<Bool>?
    
    var parameters: [String: Any] = [:]
    
    func fetchCharacters(pages: Int = 1, query: String = "", status: String = "", species: String = "", gender: String = ""){
        onCharactersLoading?(true)
    
        parameters["page"] = pages
//        parameters["name"] = query
        parameters["status"] = status
        parameters["species"] = species
        parameters["gender"] = gender
        
        service.load(parameters: parameters) { [weak self] result in
            switch result {
            case let .success(character):
                self?.onCharactersLoad?(character)
            case let .failure(error):
                self?.onCharactersError?(error)
            }
            self?.onCharactersLoading?(false)
        }
    }
}
