//
//  EpisodeListController.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import UIKit

private let reuseIdentifier = "episodeCell"

class EpisodeListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var viewModel: EpisodeViewModel?
    
    var episodes: [EpisodeResult] = []
    var filteredEpisodes: [EpisodeResult] = []
    var searchActive = false
    
    var refreshControl = UIRefreshControl()
    
    var currentPage = 1
    var isLoading = false
     
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "EpisodeCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        viewModel?.onEpisodeLoad = { [weak self] episodes in
            
            for episode in episodes {
                self?.episodes.append(episode)
                self?.filteredEpisodes.append(episode)
            }
            self?.isLoading = false
            self?.collectionView.reloadData()
        }
        
        viewModel?.onEpisodeError = { [weak self] error in
            self?.handle(error) {
                let parameters = ["page": self!.currentPage]
                self?.viewModel?.fetchEpisode(parameters: parameters)
            }
        }
        
        viewModel?.onEpisodeLoading = { [weak self] isLoading in
            if isLoading {
                self?.refreshControl.beginRefreshing()
            } else {
                self?.refreshControl.endRefreshing()
            }
        }
        
        self.navigationItem.title = "Episode"
    }
    
    private func fetchEpisode(page: Int) {
        let parameters = ["page": page]
        viewModel?.fetchEpisode(parameters: parameters)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.episodes.removeAll()
        self.filteredEpisodes.removeAll()
        fetchEpisode(page: currentPage)
    }
    
    @objc private func refresh(_ sender: Any) {
        let parameters = ["page": currentPage]
        viewModel?.fetchEpisode(parameters: parameters)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if searchActive {
            return self.filteredEpisodes.count
        } else {
            return self.episodes.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EpisodeCell
    
        if searchActive {
            let episode = filteredEpisodes[indexPath.row]
            let vm = EpisodeItemViewModel(episode: episode)
            cell.configure(vm)
        } else {
            let episode = episodes[indexPath.row]
            let vm = EpisodeItemViewModel(episode: episode)
            cell.configure(vm)
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailEpisodeController(nibName: "DetailEpisodeController", bundle: nil)

        if searchActive {
            vc.episodes = filteredEpisodes[indexPath.row]
        } else {
            vc.episodes = episodes[indexPath.row]
        }

        self.present(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let lastEpisodeCount: Int = self.episodes.count - 1

        if indexPath.row == lastEpisodeCount && currentPage < 3 {
            guard !isLoading else { return }
            isLoading = true
            currentPage += 1
            fetchEpisode(page: currentPage)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 16, height: 116)
    }
}

extension EpisodeListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText == "" {
            searchActive = false
        } else {
            filteredEpisodes = episodes.filter{ (episodes) -> Bool in
                return episodes.name.range(of: searchText, options: [ .caseInsensitive ]) != nil
            }
            searchActive = true
        }
        
        self.collectionView.reloadData()
    }
}
