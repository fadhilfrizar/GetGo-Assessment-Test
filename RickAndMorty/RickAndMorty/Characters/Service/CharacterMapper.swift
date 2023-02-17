//
//  CharacterMapping.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

enum CharacterMapper {
    struct CharacterRootResponse: Codable {
        let data: [CharacterResponse]
        
        private enum CodingKeys: String, CodingKey {
            case data = "results"
        }
        
        var character : [CharacterResult] {
            data.map { CharacterResult(id: $0.id,
                                       name: $0.name,
                                       status: $0.status,
                                       species: $0.species,
                                       type: $0.type,
                                       gender: $0.gender,
                                       origin: $0.origin,
                                       location: $0.location,
                                       image: $0.image,
                                       episode: $0.episode,
                                       url: $0.url,
                                       created: $0.created) }
        }
    }
    
    struct CharacterResponse: Codable {
        let id: Int
        let name: String
        let status: String
        let species: String
        let type: String
        let gender: String
        let origin: CharacterResultOriginAndLocation
        let location: CharacterResultOriginAndLocation
        let image: String
        let episode: [String]
        let url: String
        let created: String
    }
    
    private static var statusCode200: Int { return 200 }
    
    static func map(data: Data, response: HTTPURLResponse) -> CharacterService.Result {
        guard response.statusCode == statusCode200, let data = try? JSONDecoder().decode(CharacterRootResponse.self, from: data) else {
            return .failure(CharacterServiceAPI.Error.invalidData)
        }
        return .success(data.character)
    }
}
