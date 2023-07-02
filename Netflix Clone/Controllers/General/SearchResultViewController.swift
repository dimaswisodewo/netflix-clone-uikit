//
//  SearchResultViewController.swift
//  Netflix Clone
//
//  Created by Dimas Wisodewo on 01/07/23.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTapItem(_ model: TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {

    var searchResults: [SearchResult] = [SearchResult]()
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .systemBackground
        cell.configure(with: searchResults[indexPath.row].poster_path ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let title = searchResults[indexPath.row]
        
        APICaller.shared.getSearchYoutubeVideos(query: title.original_name ?? "") { [weak self] result in
            switch result {
            case .success(let videoId):
                guard let title = self?.searchResults[indexPath.row] else { return }
                let model = TitlePreviewViewModel(title: title.original_name ?? "", overview: title.overview ?? "", videoId: videoId)
                self?.delegate?.searchResultViewControllerDidTapItem(model)
            case.failure(let error):
                print(error)
            }
        }
    }
}
