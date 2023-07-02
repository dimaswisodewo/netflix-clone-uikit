//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Dimas Wisodewo on 01/06/23.
//

import UIKit

class DownloadsViewController: UIViewController {

    private var titles: [TitleItem] = [TitleItem]()

    private let downloadedTable: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(downloadedTable)
        
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        
        fetchDownloadedTitles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        downloadedTable.frame = view.bounds
    }
    
    private func fetchDownloadedTitles() {
        
        DataPersistenceManager.shared.fetchDownloadedTitles { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = downloadedTable.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier) as? TitleTableViewCell else {
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
        downloadedTable.deselectRow(at: indexPath, animated: true)
        
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            let title = titles[indexPath.row]
            DataPersistenceManager.shared.deleteTitleWith(model: title) { [weak self] result in
                switch result {
                case .success():
                    self?.titles.remove(at: indexPath.row)
                    self?.downloadedTable.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            break
        }
    }
}
