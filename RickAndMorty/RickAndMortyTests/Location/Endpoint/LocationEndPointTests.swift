//
//  LocationEndPointTests.swift
//  RickAndMortyTests
//
//  Created by USER-MAC-GLIT-007 on 18/02/23.
//

import Foundation
import XCTest
@testable import RickAndMorty

class LocationEndPointTests: XCTestCase {

    func test_locations_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = LocationEndpoint.get("").url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/location", "path")
        
    }

}
