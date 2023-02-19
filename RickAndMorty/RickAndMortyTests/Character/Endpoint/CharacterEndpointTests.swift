//
//  CharacterEndpointTests.swift
//  RickAndMortyTests
//
//  Created by USER-MAC-GLIT-007 on 17/02/23.
//

import Foundation
import XCTest
@testable import RickAndMorty

class CharacterEndpointTest: XCTestCase {

    func test_characters_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = CharacterEndpoint.get(page: 1).url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/character", "path")
        
    }

}
