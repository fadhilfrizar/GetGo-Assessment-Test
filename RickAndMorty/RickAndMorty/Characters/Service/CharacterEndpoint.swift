//
//  CharacterEndpoint.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

public enum CharacterEndpoint {
    
    case get(page: Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get(_):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/character"
//            components.queryItems = [
//                URLQueryItem(name: "page", value: "\(page)")
//            ].compactMap { $0 }
            return components.url!
        }
    }
}
