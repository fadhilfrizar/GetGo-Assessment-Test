//
//  EpisodeItemViewModel.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

struct EpisodeItemViewModel {
    let name: String
    let season: String
    let episodes: String
    let air_date: String
}

extension EpisodeItemViewModel {
    init(episode: EpisodeResult) {
        name = episode.name
        season = episode.episode
        episodes = ""
        air_date = episode.air_date
    }
}
