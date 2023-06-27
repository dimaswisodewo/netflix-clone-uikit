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
    
    private var titles: [Title] = [Title]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTableView)
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        
        getDiscoverMovies()
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
    }
}
