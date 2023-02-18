//
//  EpisodeListControllerTests.swift
//  RickAndMortyTests
//
//  Created by USER-MAC-GLIT-007 on 18/02/23.
//

import Foundation
import XCTest
import UIKit
@testable import RickAndMorty

class EpisodeListControllerTests: XCTestCase {
    
    func test_canInit() throws {
        _ = try makeSUT()
    }
    
    func test_viewDidLoad_setsTitle() throws {
        let sut = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.navigationItem.title, "Episode")
    }
    
    
    func test_viewDidLoad_initialState() throws {
        let sut = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfEpisodes(), 0)
    }
    
    func test_viewDidLoad_doesNotLoadEpisodeFromAPI() throws {
        let service = EpisodeServiceSpy()
        let sut = try makeSUT()
        sut.viewModel = EpisodeViewModel(service: service)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(service.loadEpisodeCount, 0)
    }
    
    func test_viewWillAppear_failedAPIResponse_showsError() throws {
        let service = EpisodeServiceSpy(result: AnyError(errorDescription: "Error: Failed API Response"))
        let sut = try makeTestableSUT()
        sut.viewModel = EpisodeViewModel(service: service)
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(sut.errorMessage(), "Error: Failed API Response")
    }
    
    func test_viewWillAppear_loadEpisodeFromAPI() throws {
        let service = EpisodeServiceSpy()
        let sut = try makeSUT()
        sut.viewModel = EpisodeViewModel(service: service)
        
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(service.loadEpisodeCount, 1)
    }
    
    func test_viewDidLoad_rendersEpisode() throws {
        let sut = try makeSUT()
        let service = EpisodeServiceSpy(result: [makeEpisodes(id: 1, name: "Pilot", air_date: "13 December 2013", episode: "S01E02", characters: [""], url: "", created: "")])
        sut.viewModel = EpisodeViewModel(service: service)
        
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(sut.numberOfEpisodes(), 1)
        XCTAssertEqual(sut.name(atRow: 0), "Pilot")
        XCTAssertEqual(sut.season(atRow: 0), "S01E02")
        XCTAssertEqual(sut.airDate(atRow: 0), "Air date: \n13 December 2013")
        
    }
    
    func makeSUT() throws -> EpisodeListController {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let vc = EpisodeListController(collectionViewLayout: layout)
        
        let sut = try XCTUnwrap(vc)
        return sut
    }
    
    func makeTestableSUT() throws -> TestableEpisodeViewController {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let vc = TestableEpisodeViewController(collectionViewLayout: layout)
        let sut = try XCTUnwrap(vc)
        return sut
    }
}

private func makeEpisodes(id: Int, name: String, air_date: String, episode: String, characters: [String], url: String, created: String) -> EpisodeResult {
    EpisodeResult(id: id, name: name, air_date: air_date, episode: episode, characters: characters, url: url, created: created)
}

extension EpisodeListController {
    
    func numberOfEpisodes() -> Int {
        collectionView.numberOfItems(inSection: episodeSection)
    }

    func name(atRow row: Int) -> String? {
        episodeCell(atRow: row)?.nameLabel.text
    }

    func season(atRow row: Int) -> String? {
        episodeCell(atRow: row)?.seasonLabel.text
    }
    
    func airDate(atRow row: Int) -> String? {
        episodeCell(atRow: row)?.airDateLabel.text
    }
    
    func episodeCell(atRow row: Int) -> EpisodeCell? {
        let ds = self.collectionView.dataSource
        let indexPath = IndexPath(row: row, section: episodeSection)
        return ds?.collectionView(self.collectionView, cellForItemAt: indexPath) as? EpisodeCell
    }
    
    private var episodeSection: Int { 0 }
    
}

class TestableEpisodeViewController: EpisodeListController {
    var presentedVC: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedVC = viewControllerToPresent
    }
    
    func errorMessage() -> String? {
        let alert = presentedVC as? UIAlertController
        return alert?.message
    }
}
