//
//  CharacterAPI.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

protocol CharacterService {
    typealias Result = Swift.Result<[CharacterResult], Error>
    
    func load(parameters: [String: Any]?, completion: @escaping (Result) -> Void)
}

class CharacterServiceAPI: CharacterService {
    
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(parameters: [String: Any]?, completion: @escaping (CharacterService.Result) -> Void) {
        client.get(from: url, parameters: parameters) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(CharacterMapper.map(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
