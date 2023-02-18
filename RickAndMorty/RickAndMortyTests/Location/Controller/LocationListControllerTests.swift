//
//  LocationListControllerTests.swift
//  RickAndMortyTests
//
//  Created by USER-MAC-GLIT-007 on 18/02/23.
//

import Foundation
import XCTest
import UIKit
@testable import RickAndMorty

class LocationListControllerTests: XCTestCase {
    
    func test_canInit() throws {
        _ = try makeSUT()
    }
    
    func test_viewDidLoad_setsTitle() throws {
        let sut = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.navigationItem.title, "Location")
    }
    
    
    func test_viewDidLoad_initialState() throws {
        let sut = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfLocations(), 0)
    }
    
    func test_viewDidLoad_doesNotLoadLocationFromAPI() throws {
        let service = LocationServiceSpy()
        let sut = try makeSUT()
        sut.viewModel = LocationViewModel(service: service)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(service.loadLocationCount, 0)
    }
    
    func test_viewWillAppear_failedAPIResponse_showsError() throws {
        let service = LocationServiceSpy(result: AnyError(errorDescription: "Error: Failed API Response"))
        let sut = try makeTestableSUT()
        sut.viewModel = LocationViewModel(service: service)
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(sut.errorMessage(), "Error: Failed API Response")
    }
    
    func test_viewWillAppear_loadLocationFromAPI() throws {
        let service = LocationServiceSpy()
        let sut = try makeSUT()
        sut.viewModel = LocationViewModel(service: service)
        
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(service.loadLocationCount, 1)
    }
    
    func test_viewDidLoad_rendersLocation() throws {
        let sut = try makeSUT()
        let service = LocationServiceSpy(result: [makeLocations(id: 1, name: "Earth", type: "Planet", dimension: "Dimension C-137", residents: ["https://rickandmortyapi.com/api/character/1"], url: "", created: "")])
        sut.viewModel = LocationViewModel(service: service)
        
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(sut.numberOfLocations(), 1)
        XCTAssertEqual(sut.name(atRow: 0), "Earth")
        XCTAssertEqual(sut.type(atRow: 0), "Planet")
        XCTAssertEqual(sut.dimension(atRow: 0), "Dimension : \nDimension C-137")
//        XCTAssertEqual(sut.image(atRow: 0), "https://urlImage.com")
        
    }
    
    func makeSUT() throws -> LocationListController {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let vc = LocationListController(collectionViewLayout: layout)
        
        let sut = try XCTUnwrap(vc)
        return sut
    }
    
    func makeTestableSUT() throws -> TestableLocationViewController {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let vc = TestableLocationViewController(collectionViewLayout: layout)
        let sut = try XCTUnwrap(vc)
        return sut
    }
}

private func makeLocations(id: Int, name: String, type: String, dimension: String, residents: [String], url: String, created: String) -> LocationResult {
    LocationResult(id: id, name: name, type: type, dimension: dimension, residents: residents, url: url, created: created)
}

extension LocationListController {
    
    func numberOfLocations() -> Int {
        collectionView.numberOfItems(inSection: locationSection)
    }

    func name(atRow row: Int) -> String? {
        locationCell(atRow: row)?.nameLabel.text
    }
//
    func type(atRow row: Int) -> String? {
        locationCell(atRow: row)?.typeLabel.text
    }
    
    func dimension(atRow row: Int) -> String? {
        locationCell(atRow: row)?.dimensionLabel.text
    }
    
    func locationCell(atRow row: Int) -> LocationCell? {
        let ds = self.collectionView.dataSource
        let indexPath = IndexPath(row: row, section: locationSection)
        return ds?.collectionView(self.collectionView, cellForItemAt: indexPath) as? LocationCell
    }
    
    private var locationSection: Int { 0 }
    
}

class TestableLocationViewController: LocationListController {
    var presentedVC: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedVC = viewControllerToPresent
    }
    
    func errorMessage() -> String? {
        let alert = presentedVC as? UIAlertController
        return alert?.message
    }
}
