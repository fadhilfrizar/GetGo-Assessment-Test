//
//  CharacterListControllerTests.swift
//  RickAndMortyTests
//
//  Created by USER-MAC-GLIT-007 on 17/02/23.
//

import Foundation
import XCTest
import UIKit
@testable import RickAndMorty

class CharacterListControllerTests: XCTestCase {
    
    func test_canInit() throws {
        _ = try makeSUT()
    }
    
    func test_viewDidLoad_setsTitle() throws {
        let sut = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.navigationItem.title, "Character")
    }
    
    
    func test_viewDidLoad_initialState() throws {
        let sut = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfCharacters(), 0)
    }
    
    func test_viewDidLoad_doesNotLoadCharacterFromAPI() throws {
        let service = CharacterServiceSpy()
        let sut = try makeSUT()
        sut.viewModel = CharactersViewModel(service: service)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(service.loadCharacterCount, 0)
    }
    
    func test_viewWillAppear_failedAPIResponse_showsError() throws {
        let service = CharacterServiceSpy(result: AnyError(errorDescription: "Error: Failed API Response"))
        let sut = try makeTestableSUT()
        sut.viewModel = CharactersViewModel(service: service)
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(sut.errorMessage(), "Error: Failed API Response")
    }
    
    func test_viewWillAppear_loadCharactersFromAPI() throws {
        let service = CharacterServiceSpy()
        let sut = try makeSUT()
        sut.viewModel = CharactersViewModel(service: service)
        
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(service.loadCharacterCount, 1)
    }
    
    func test_viewDidLoad_rendersCharacter() throws {
        let sut = try makeSUT()
        let service =  CharacterServiceSpy(result: [makeCharacters(id: 1, name: "Rick Sanchez", status: "", species: "Human", type: "", gender: "", origin: CharacterResultOriginAndLocation(name: "", url: ""), location: CharacterResultOriginAndLocation(name: "", url: ""), image: "https://urlImage.com", episode: [], url: "", created: "")])
        sut.viewModel = CharactersViewModel(service: service)
        
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(sut.numberOfCharacters(), 1)
        XCTAssertEqual(sut.name(atRow: 0), "Rick Sanchez")
        XCTAssertEqual(sut.species(atRow: 0), "Human")
//        XCTAssertEqual(sut.image(atRow: 0), "https://urlImage.com")
        
    }
    
    func makeSUT() throws -> CharactersListController {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let vc = CharactersListController(collectionViewLayout: layout)
        
        let sut = try XCTUnwrap(vc)
        return sut
    }
    
    func makeTestableSUT() throws -> TestableCharacterViewController {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let vc = TestableCharacterViewController(collectionViewLayout: layout)
        let sut = try XCTUnwrap(vc)
        return sut
    }
}

private func makeCharacters(id: Int, name: String, status: String, species: String, type: String, gender: String, origin: CharacterResultOriginAndLocation, location: CharacterResultOriginAndLocation, image: String, episode: [String], url: String, created: String) -> CharacterResult {
    CharacterResult(id: id, name: name, status: status, species: species, type: type, gender: gender, origin: origin, location: location, image: image, episode: episode, url: url, created: created)
}

extension CharactersListController {
    
    func numberOfCharacters() -> Int {
        collectionView.numberOfItems(inSection: characterSection)
    }

//    func image(atRow row: Int) -> String? {
//        characterCell(atRow: row)?.characterImageView.loadImageUsingCacheWithUrlString("") as? String
//    }
//
    func name(atRow row: Int) -> String? {
        characterCell(atRow: row)?.characterNameLabel.text
    }
    
    func species(atRow row: Int) -> String? {
        characterCell(atRow: row)?.characterSpeciesLabel.text
    }
    
    func characterCell(atRow row: Int) -> CharacterCell? {
        let ds = self.collectionView.dataSource
        let indexPath = IndexPath(row: row, section: characterSection)
        return ds?.collectionView(self.collectionView, cellForItemAt: indexPath) as? CharacterCell
    }
    
    private var characterSection: Int { 0 }
    
}

class TestableCharacterViewController: CharactersListController {
    var presentedVC: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedVC = viewControllerToPresent
    }
    
    func errorMessage() -> String? {
        let alert = presentedVC as? UIAlertController
        return alert?.message
    }
}

struct AnyError: LocalizedError {
    var errorDescription: String?
}
