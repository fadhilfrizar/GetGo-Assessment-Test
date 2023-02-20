//
//  EpisodeViewModel.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

class EpisodeViewModel {
    private let service: EpisodeService
    
    init(service: EpisodeService){
        self.service = service
    }
    
    typealias Observer<T> = (T) -> Void
    
    var onEpisodeLoad: Observer<[EpisodeResult]>?
    var onEpisodeError: Observer<Error>?
    var onEpisodeLoading: Observer<Bool>?
    
    func fetchEpisode(parameters: [String: Any]?){
        onEpisodeLoading?(true)
        service.load(parameters: parameters) { [weak self] result in
            switch result {
            case let .success(episode):
                self?.onEpisodeLoad?(episode)
            case let .failure(error):
                self?.onEpisodeError?(error)
            }
            self?.onEpisodeLoading?(false)
        }
    }
}
