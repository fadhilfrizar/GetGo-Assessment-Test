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
        let service =  CharacterServiceSpy(result: [makeCharacters(id: 21,
                                                                   name: "Aqua Morty",
                                                                   status: "unknown",
                                                                   species: "Humanoid",
                                                                   type: "Fish-Person",
                                                                   gender: "Male",
                                                                   origin: CharacterResultOriginAndLocation(name: "unknown", url: ""),
                                                                   location: CharacterResultOriginAndLocation(name: "Citadel of Ricks",
                                                                                                              url: "https://rickandmortyapi.com/api/location/3"),
                                                                   image: "https://rickandmortyapi.com/api/character/avatar/21.jpeg",
                                                                   episode: ["https://rickandmortyapi.com/api/episode/10", "https://rickandmortyapi.com/api/episode/22"],
                                                                   url: "https://rickandmortyapi.com/api/character/21",
                                                                   created: "2017-11-04T22:39:48.055Z")])
        sut.viewModel = CharactersViewModel(service: service)
        
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        
        XCTAssertEqual(sut.numberOfCharacters(), 1)
        XCTAssertEqual(sut.name(atRow: 0), "Aqua Morty")
        XCTAssertEqual(sut.species(atRow: 0), "Humanoid")
        //        XCTAssertEqual(sut.image(atRow: 0), "https://urlImage.com")
        
    }
    
    func test_viewDidLoad_searchCharacter() throws {
        let sut = try makeSUT()
        let filteredCharacter = sut.filteredCharacter
        let characters = sut.characters
        
        if sut.searchActive {
            sut.filteredCharacter = sut.characters.filter{ (characters) -> Bool in
                return characters.name.range(of: sut.searchText, options: [ .caseInsensitive ]) != nil
            }
        }
        
        XCTAssertEqual(sut.filteredCharacter, filteredCharacter)
        XCTAssertEqual(sut.characters, characters)
        
    }
    
    func test_viewDidLoad_searchIsNotActive() throws {
        let sut = try makeSUT()
        let searchText = sut.searchText
        
        if !sut.searchActive {
            sut.searchText = ""
        }
        
        XCTAssertEqual(sut.searchText, searchText)
        
    }
    
    func makeSUT() throws -> CharactersListController {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let vc = CharactersListController(collectionViewLayout: layout)
        
        return vc
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
