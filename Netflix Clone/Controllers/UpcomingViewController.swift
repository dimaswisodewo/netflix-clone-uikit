//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Dimas Wisodewo on 01/06/23.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var titles: [Title] = [Title]()

    private let upcomingTable: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        getUpcomingMovies()
    }

    override func viewDidLayoutSubviews() {
        upcomingTable.frame = view.bounds
    }
    
    private func getUpcomingMovies() {
        APICaller.shared.getUpcomingMovies { [weak self] results in
            switch results {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = upcomingTable.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        if titles.isEmpty {
            return cell
        }
        
        cell.configure(with: TitleViewModel(titleName: titles[indexPath.row].original_title ?? "Unknown title",
                                            posterURL: titles[indexPath.row].poster_path ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        upcomingTable.deselectRow(at: indexPath, animated: true)
    }
}
