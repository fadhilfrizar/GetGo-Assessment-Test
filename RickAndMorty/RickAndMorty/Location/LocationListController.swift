//
//  LocationListController.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import UIKit

private let reuseIdentifier = "locationCell"

class LocationListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var viewModel: LocationViewModel?
    
    var locations: [LocationResult] = []
    var filteredLocations: [LocationResult] = []
    var searchActive = false
    
    var refreshControl = UIRefreshControl()

    var currentPage = 1
    var isLoading = false
     
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "LocationCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        viewModel?.onLocationLoad = { [weak self] locations in
            for location in locations {
                self?.locations.append(location)
                self?.filteredLocations.append(location)
            }
            
            self?.collectionView.reloadData()
            self?.isLoading = false
        }
        
        viewModel?.onLocationError = { [weak self] error in
            self?.handle(error) {
                let parameters = ["page": self!.currentPage]
                self?.viewModel?.fetchLocations(parameters: parameters)
            }
        }
        
        viewModel?.onLocationLoading = { [weak self] isLoading in
            if isLoading {
                self?.refreshControl.beginRefreshing()
            } else {
                self?.refreshControl.endRefreshing()
            }
        }
        
        self.navigationItem.title = "Location"
    }
    
    private func fetchLocation(page: Int) {
        let parameters = ["page": page]
        viewModel?.fetchLocations(parameters: parameters)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.locations.removeAll()
        self.filteredLocations.removeAll()
        
        fetchLocation(page: currentPage)
    }
    
    @objc private func refresh(_ sender: Any) {
        let parameters = ["page": currentPage]
        viewModel?.fetchLocations(parameters: parameters)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if searchActive {
            return self.filteredLocations.count
        } else {
            return self.locations.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
    
        if searchActive {
            let location = filteredLocations[indexPath.row]
            let vm = LocationItemViewModel(location: location)
            cell.configure(vm)
        } else {
            let location = locations[indexPath.row]
            let vm = LocationItemViewModel(location: location)
            cell.configure(vm)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailLocationController(nibName: "DetailLocationController", bundle: nil)

        if searchActive {
            vc.locations = filteredLocations[indexPath.row]
        } else {
            vc.locations = locations[indexPath.row]
        }

        self.present(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let lastLocationCount: Int = self.locations.count - 1

        if indexPath.row == lastLocationCount && currentPage < 7 {
            guard !isLoading else { return }
            isLoading = true
            currentPage += 1
            fetchLocation(page: currentPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 32, height: 80)
    }
}

extension LocationListController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText == "" {
            searchActive = false
        } else {
            filteredLocations = locations.filter{ (locations) -> Bool in
                return locations.name.range(of: searchText, options: [ .caseInsensitive ]) != nil
            }
            searchActive = true
        }
        
        self.collectionView.reloadData()
    }
    
}
