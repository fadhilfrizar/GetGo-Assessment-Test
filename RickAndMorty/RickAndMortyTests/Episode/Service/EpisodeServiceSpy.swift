//
//  EpisodeServiceSpy.swift
//  RickAndMortyTests
//
//  Created by USER-MAC-GLIT-007 on 18/02/23.
//

import Foundation
@testable import RickAndMorty

class EpisodeServiceSpy: EpisodeService {
    
    private(set) var loadEpisodeCount = 0
    private let result: Result<[EpisodeResult], Error>
    
    init(result: [EpisodeResult] = []){
        self.result = .success(result)
    }
    
    init(result: Error){
        self.result = .failure(result)
    }
    
    func load(parameters: [String : Any]?, completion: @escaping (Result<[EpisodeResult], Error>) -> Void) {
        loadEpisodeCount += 1
        completion(result)
    }
    
}
