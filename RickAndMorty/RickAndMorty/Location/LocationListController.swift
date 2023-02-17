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
     
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "LocationCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        viewModel?.onLocationLoad = { [weak self] location in
            self?.locations = location
            self?.filteredLocations = location
            self?.collectionView.reloadData()
        }
        
        viewModel?.onLocationError = { [weak self] error in
            self?.handle(error) {
                self?.viewModel?.fetchLocations()
            }
        }
        
        viewModel?.onLocationLoading = { [weak self] isLoading in
            if isLoading {
                self?.refreshControl.beginRefreshing()
            } else {
                self?.refreshControl.endRefreshing()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchLocations()
    }
    
    @objc private func refresh(_ sender: Any) {
        viewModel?.fetchLocations()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

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
