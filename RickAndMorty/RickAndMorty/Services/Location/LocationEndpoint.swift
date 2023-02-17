//
//  LocationEndpoint.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import Foundation

public enum LocationEndpoint {
    
    case get(_ : String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get(_):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/location"
//            components.queryItems = [
//                URLQueryItem(name: "lang", value: "EN"),
//                URLQueryItem(name: "categories", value: category)
//            ].compactMap { $0 }
            return components.url!
        }
    }
}
