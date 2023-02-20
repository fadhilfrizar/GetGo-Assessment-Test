//
//  LocationViewModel.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

class LocationViewModel {
    private let service: LocationService
    
    init(service: LocationService){
        self.service = service
    }
    
    typealias Observer<T> = (T) -> Void
    
    var onLocationLoad: Observer<[LocationResult]>?
    var onLocationError: Observer<Error>?
    var onLocationLoading: Observer<Bool>?
    
    func fetchLocations(parameters: [String: Any]?){
        onLocationLoading?(true)
        service.load(parameters: parameters) { [weak self] result in
            switch result {
            case let .success(location):
                self?.onLocationLoad?(location)
            case let .failure(error):
                self?.onLocationError?(error)
            }
            self?.onLocationLoading?(false)
        }
    }
}
