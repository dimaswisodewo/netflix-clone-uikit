//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Dimas Wisodewo on 01/06/23.
//

import UIKit

class SearchViewController: UIViewController {

    private let discoverTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    private let searchResultViewController = SearchResultViewController()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: self.searchResultViewController)
        controller.searchBar.placeholder = "Search for a Movie or a Tv Show title"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private var titles: [Title] = [Title]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.tintColor = .label
        navigationItem.searchController?.searchResultsUpdater = self // Search everytime the text field updated
//        navigationItem.searchController?.searchBar.delegate = self // Search on pressed enter
        
        searchResultViewController.delegate = self
        
        view.addSubview(discoverTableView)
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        
        getDiscoverMovies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.searchController?.searchBar.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        discoverTableView.frame = view.bounds
    }
    
    private func getDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = discoverTableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier) as? TitleTableViewCell else {
            return UITableViewCell()
        }

        if titles.isEmpty {
            return cell
        }
        
        let title = titles[indexPath.row]
        let titleViewModel = TitleViewModel(titleName: title.original_title ?? "Unknown title", posterURL: title.poster_path ?? "")
        cell.configure(with: titleViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        discoverTableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title else { return }
        
        APICaller.shared.getSearchYoutubeVideos(query: titleName) { result in
            switch result {
            case .success(let videoId):
                let model = TitlePreviewViewModel(title: titleName, overview: title.overview ?? "", videoId: videoId)
                DispatchQueue.main.async { [weak self] in
                    let vc = TitlePreviewViewController()
                    vc.configure(model: model)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchViewController: SearchResultViewControllerDelegate {
    
    func searchResultViewControllerDidTapItem(_ model: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(model: model)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {

    // Search everytime the text field updated
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar

        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3
        else {
            return
        }

        APICaller.shared.getSearchCollection(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let searchResults):
                    self?.searchResultViewController.searchResults = searchResults
                    self?.searchResultViewController.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

//extension SearchViewController: UISearchBarDelegate {
//
//    // Search on pressed enter
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        guard let query = searchBar.text,
//              !query.trimmingCharacters(in: .whitespaces).isEmpty
//        else {
//            return
//        }
//
//        print("Search query: \(query)")
//
//        APICaller.shared.getSearchCollection(query: query) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let searchResults):
//                    self?.searchResultViewController.searchResults = searchResults
//                    self?.searchResultViewController.collectionView.reloadData()
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }
//    }
//}
