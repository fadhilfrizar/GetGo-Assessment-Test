//
//  Episode.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

//struct EpisodeModel: Codable {
//    var info: InfoModel
//    var result: [EpisodeResult]
//}

struct EpisodeResult {
    var id: Int
    var name: String
    var air_date: String
    var episode: String
    var characters: [String]
    var url: String
    var created: String
}

extension EpisodeResult: Equatable {}
