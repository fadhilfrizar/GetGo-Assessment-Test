//
//  EpisodeMapper.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

enum EpisodeMapper {
    struct EpisodeRootResponse: Codable {
        let data: [EpisodeResponse]
        
        private enum CodingKeys: String, CodingKey {
            case data = "results"
        }
        
        var episode : [EpisodeResult] {
            data.map { EpisodeResult(id: $0.id, name: $0.name, air_date: $0.air_date, episode: $0.episode, characters: $0.characters, url: $0.url, created: $0.created) }
        }
    }
    
    struct EpisodeResponse: Codable {
        var id: Int
        var name: String
        var air_date: String
        var episode: String
        var characters: [String]
        var url: String
        var created: String
    }
    
    private static var statusCode200: Int { return 200 }
    
    static func map(data: Data, response: HTTPURLResponse) -> EpisodeService.Result {
        guard response.statusCode == statusCode200, let data = try? JSONDecoder().decode(EpisodeRootResponse.self, from: data) else {
            return .failure(EpisodeServiceAPI.Error.invalidData)
        }
        return .success(data.episode)
    }
}
