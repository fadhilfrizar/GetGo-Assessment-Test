//
//  LocationAPI.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

protocol LocationService {
    typealias Result = Swift.Result<[LocationResult], Error>
    
    func load(parameters: [String: Any]?, completion: @escaping (Result) -> Void)
}

class LocationServiceAPI: LocationService {
    
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
    
    func load(parameters: [String: Any]?, completion: @escaping (LocationService.Result) -> Void) {
        client.get(from: url, parameters: parameters) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(LocationMapper.map(data: data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}


//struct LocationService {
//
//    static let url = "https://rickandmortyapi.com/api/location"
//
//    static func loadCategories(completion: @escaping (Result<LocationModel, Error>) -> Void) {
//
//        let endpoint = url
//        guard let url = URL(string: endpoint) else { return }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            guard let data = data else { return }
//            do {
//                let decodedData = try JSONDecoder().decode(LocationModel.self, from: data)
//                completion(.success(decodedData))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//        task.resume()
//    }
//}
