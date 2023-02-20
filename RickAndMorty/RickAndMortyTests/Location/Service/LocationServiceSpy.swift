//
//  LocationServiceSpy.swift
//  RickAndMortyTests
//
//  Created by USER-MAC-GLIT-007 on 18/02/23.
//

import Foundation
@testable import RickAndMorty

class LocationServiceSpy: LocationService {
    
    private(set) var loadLocationCount = 0
    private let result: Result<[LocationResult], Error>
    
    init(result: [LocationResult] = []){
        self.result = .success(result)
    }
    
    init(result: Error){
        self.result = .failure(result)
    }
    
    func load(parameters: [String: Any]?, completion: @escaping (Result<[LocationResult], Error>) -> Void) {
        loadLocationCount += 1
        completion(result)
    }
    
}
