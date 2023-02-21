//
//  MainTabBarController.swift
//  RickAndMorty
//
//  Created by USER-MAC-GLIT-007 on 16/02/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    private lazy var baseURL = URL(string: "https://rickandmortyapi.com/api")!
    
    var pages: Int = 1
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.setupViewController()
    }
    
    private func setupViewController() {
        viewControllers = [
            makeNavWithLargeTitle(for: makeCharacterList(), title: "Character", icon: "person.2.fill"),
            makeNav(for: makeLocationList(), title: "Location", icon: "location.fill"),
            makeNav(for: makeEpisodeList(), title: "Episode", icon: "video.fill"),
            
        ]
    }
    
    private func makeNavWithLargeTitle(for vc: UIViewController, title: String, icon: String) -> UIViewController {
        
        vc.navigationItem.largeTitleDisplayMode = .always
        vc.navigationItem.hidesSearchBarWhenScrolling = false
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        nav.tabBarItem.title = title
        nav.navigationBar.prefersLargeTitles = true
        
        return nav
        
    }
    
    private func makeNav(for vc: UIViewController, title: String, icon: String) -> UIViewController {
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.navigationItem.hidesSearchBarWhenScrolling = false
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        nav.tabBarItem.title = title
        nav.navigationBar.prefersLargeTitles = false
        
        return nav
        
    }
    
    private func makeCharacterList() -> CharactersListController {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        layout.collectionView?.alwaysBounceVertical = true
        
        let vc = CharactersListController(collectionViewLayout: layout)
        vc.title = "Character"
        let image = UIImage(systemName: "slider.horizontal.3", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: vc, action: #selector(vc.filterCharacter))
        
        let searchController = UISearchController(searchResultsController: nil)
        vc.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = vc
        
        vc.viewModel = CharactersViewModel(service: MainQueueDispatchDecorator(decoratee: CharacterServiceAPI(url: CharacterEndpoint.get(page: pages).url(baseURL: baseURL), client: httpClient)))
        
        return vc
    }
    
    private func makeLocationList() -> LocationListController {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        
        let vc = LocationListController(collectionViewLayout: layout)
        vc.title = "Location"
        
        let searchController = UISearchController(searchResultsController: nil)
        vc.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = vc
        
        
        vc.viewModel = LocationViewModel(service: MainQueueDispatchDecorator(decoratee: LocationServiceAPI(url: LocationEndpoint.get("").url(baseURL: baseURL), client: httpClient)))
        
        return vc
    }
    
    private func makeEpisodeList() -> EpisodeListController {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        
        let vc = EpisodeListController(collectionViewLayout: layout)
        vc.navigationItem.title = "Episode"
        
        let searchController = UISearchController(searchResultsController: nil)
        vc.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = vc
        
        vc.viewModel = EpisodeViewModel(service: MainQueueDispatchDecorator(decoratee: EpisodeServiceAPI(url: EpisodeEndpoint.get("").url(baseURL: baseURL), client: httpClient)))
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
