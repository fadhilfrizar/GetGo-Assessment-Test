//
//  LocationMapper.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

enum LocationMapper {
    struct LocationRootResponse: Codable {
        let data: [LocationResponse]
        
        private enum CodingKeys: String, CodingKey {
            case data = "results"
        }
        
        var location : [LocationResult] {
            data.map { LocationResult(id: $0.id, name: $0.name, type: $0.type, dimension: $0.dimension, residents: $0.residents, url: $0.url, created: $0.created) }
        }
    }
    
    struct LocationResponse: Codable {
        let id: Int
        let name: String
        let type: String
        let dimension: String
        let residents: [String]
        let url: String
        let created: String
    }
    
    private static var statusCode200: Int { return 200 }
    
    static func map(data: Data, response: HTTPURLResponse) -> LocationService.Result {
        guard response.statusCode == statusCode200, let data = try? JSONDecoder().decode(LocationRootResponse.self, from: data) else {
            return .failure(LocationServiceAPI.Error.invalidData)
        }
        return .success(data.location)
    }
}
