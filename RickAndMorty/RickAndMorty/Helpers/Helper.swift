//
//  Helper.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: EpisodeService where T == EpisodeService {
    func load(parameters: [String: Any]?, completion: @escaping (EpisodeService.Result) -> Void) {
        decoratee.load(parameters: parameters) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}


extension MainQueueDispatchDecorator: LocationService where T == LocationService {
    func load(parameters: [String: Any]?, completion: @escaping (LocationService.Result) -> Void) {
        decoratee.load(parameters: parameters) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}


extension MainQueueDispatchDecorator: CharacterService where T == CharacterService {
    func load(parameters: [String: Any]?, completion: @escaping (CharacterService.Result) -> Void) {
        decoratee.load(parameters: parameters) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
