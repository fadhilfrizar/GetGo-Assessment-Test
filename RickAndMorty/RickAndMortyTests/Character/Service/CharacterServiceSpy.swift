//
//  CharacterServiceSpy.swift
//  RickAndMortyTests
//
//  Created by USER-MAC-GLIT-007 on 17/02/23.
//

import Foundation
@testable import RickAndMorty

class CharacterServiceSpy: CharacterService {
    
    private(set) var loadCharacterCount = 0
    private let result: Result<[CharacterResult], Error>
    
    init(result: [CharacterResult] = []){
        self.result = .success(result)
    }
    
    init(result: Error){
        self.result = .failure(result)
    }
    
    func load(parameters: [String : Any]?, completion: @escaping (Result<[CharacterResult], Error>) -> Void) {
        loadCharacterCount += 1
        completion(result)
    }
    
}
