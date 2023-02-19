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
    
    var characters: [CharacterResult] = []
    var filteredCharacter: [CharacterResult] = []
    var searchActive = false
    
    var refreshControl = UIRefreshControl()
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    private lazy var baseURL = URL(string: "https://rickandmortyapi.com/api")!
    
    var currentPage = 1
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CharacterCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        self.navigationItem.title = "Character"
        
        
    }
    
    func initViewModel(page: Int) {
        viewModel = CharactersViewModel(service: MainQueueDispatchDecorator(decoratee: CharacterServiceAPI(url: CharacterEndpoint.get(page: page).url(baseURL: baseURL), client: httpClient)))
        
        viewModel?.fetchCharacters()
        
        viewModel?.onCharactersLoad = { [weak self] characters in
            
            for character in characters {
                self?.characters.append(character)
                self?.filteredCharacter.append(character)
            }
            
            self?.collectionView.reloadData()
            self?.isLoading = false
            
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViewModel(page: currentPage)
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
        let vc = DetailCharacterController(nibName: "DetailCharacterController", bundle: nil)
        
        if searchActive {
            vc.characters = filteredCharacter[indexPath.row]
        } else {
            vc.characters = characters[indexPath.row]
        }
        
        show(vc, sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastCharacterCount: Int = self.characters.count - 1

        if indexPath.row == lastCharacterCount && currentPage <= 10 {
            guard !isLoading else { return }
            isLoading = true
            currentPage += 1
            initViewModel(page: currentPage)
//            if let customTabBarController = self.tabBarController as? MainTabBarController {
//                customTabBarController.pages = currentPage
//            }

        }
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
