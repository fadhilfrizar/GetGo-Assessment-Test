//
//  EpisodeEndPointTests.swift
//  RickAndMortyTests
//
//  Created by USER-MAC-GLIT-007 on 18/02/23.
//

import Foundation
import XCTest
@testable import RickAndMorty

class EpisodeEndPointTests: XCTestCase {

    func test_episodes_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = EpisodeEndpoint.get("").url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/episode", "path")
        
    }

}
