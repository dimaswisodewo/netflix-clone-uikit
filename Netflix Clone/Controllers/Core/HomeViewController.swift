//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Dimas Wisodewo on 01/06/23.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTvs = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = [
        "Trending Movies",
        "Popular",
        "Trending TV",
        "Upcoming Movies",
        "Top Rated"
    ]
    
    private let homeFeedTable: UITableView = {
        
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: 0, height: 460))
    
    private var randomTrendingMovie: Title?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 460)
        homeFeedTable.tableHeaderView = headerView

        configureNavbar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureHeroHeaderImage(model: Title) {
        randomTrendingMovie = model
        headerView.configure(model: model.poster_path ?? "")
    }
    
    private func configureNavbar() {
        
        var image = UIImage(named: "NetflixLogoInitial")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = image
        
        let imageContainer = UIControl(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageContainer.addTarget(self, action: #selector(leftBarButtonPressed), for: .touchUpInside)
        imageContainer.addSubview(imageView)
        
        let leftBarButtonItem = UIBarButtonItem(customView: imageContainer)
        leftBarButtonItem.width = 20
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .label
    }
    
    @objc private func leftBarButtonPressed() {
        
        print("Pressed left bar button item")
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier) as? CollectionViewTableViewCell  else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { [weak self] results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                    guard let randomTrendingMovie = titles.randomElement() else { return }
                    self?.configureHeroHeaderImage(model: randomTrendingMovie)
                case .failure(let error):
                    print("TrendingMovies Error: \(error)")
                }
            }
        case Sections.TrendingTvs.rawValue:
            APICaller.shared.getTrendingTvs { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print("TrendingTvs Error: \(error)")
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print("Popular Error: \(error)")
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print("Upcoming Error: \(error)")
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { results in
                switch results {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print("TopRated Error: \(error)")
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            print("Failed get header")
            return
        }

        var contentConfig = header.defaultContentConfiguration()
        contentConfig.directionalLayoutMargins = .init(top: 0, leading: 20, bottom: 0, trailing: 0)
        contentConfig.textProperties.font = .systemFont(ofSize: 18, weight: .semibold)
        contentConfig.textProperties.color = .label
        contentConfig.textProperties.transform = .capitalized
        contentConfig.text = sectionTitles[section]

        header.contentConfiguration = contentConfig
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let label = UILabel()
//        label.sizeToFit()
//        label.font = .systemFont(ofSize: 18, weight: .bold)
//        label.text = sectionTitles[section]
//        return label
//    }
//
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
//        print("Offset: \(offset), contentOffset.y: \(scrollView.contentOffset.y)")
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    
    func collectionViewTableViewCellDidTapCell(_: CollectionViewTableViewCell, model: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let viewController = TitlePreviewViewController()
            viewController.configure(model: model)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
