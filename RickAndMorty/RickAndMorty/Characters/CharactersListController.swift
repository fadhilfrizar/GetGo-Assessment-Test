//
//  ViewController.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import UIKit

private let reuseIdentifier = "characterCell"

class CharactersListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
    var viewModel: CharactersViewModel?
    
    var characters: [CharacterResult] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var filteredCharacter: [CharacterResult] = []
    var searchActive = false
    
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CharacterCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        viewModel?.onCharactersLoad = { [weak self] characters in
            self?.characters = characters
            self?.filteredCharacter = characters

        }
        
        viewModel?.onCharactersError = { [weak self] error in
            self?.handle(error) {
                self?.viewModel?.fetchCharacters()
            }
        }
        
        viewModel?.onCharactersLoading = { [weak self] isLoading in
            if isLoading {
                self?.refreshControl.beginRefreshing()
            } else {
                self?.refreshControl.endRefreshing()
            }
        }
        
        self.navigationItem.title = "Characters"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchCharacters()
    }
    
    @objc private func refresh(_ sender: Any) {
        viewModel?.fetchCharacters()
    }
    
    
    @objc func filterCharacter(_ sender: UIButton) {
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return self.filteredCharacter.count
        } else {
            return self.characters.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CharacterCell
        
        if searchActive {
            let filteredCharacters = filteredCharacter[indexPath.row]
            let vm = CharactersItemViewModel(characters: filteredCharacters)
            cell.configure(vm)
        } else {
            let characters = characters[indexPath.row]
            let vm = CharactersItemViewModel(characters: characters)
            cell.configure(vm)
        }
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 2 - 16, height: 250)
        
    }
    
}

extension CharactersListController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText == "" {
            searchActive = false
        } else {
            filteredCharacter = characters.filter{ (characters) -> Bool in
                return characters.name.range(of: searchText, options: [ .caseInsensitive ]) != nil
            }
            searchActive = true
        }
        
        self.collectionView.reloadData()
    }
    
}
