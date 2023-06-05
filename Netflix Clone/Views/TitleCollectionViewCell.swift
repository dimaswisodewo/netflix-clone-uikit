//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Dimas Wisodewo on 04/06/23.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var isImageLoaded: Bool = false
    
    override init(frame: CGRect) { 
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String) {
        
        guard !isImageLoaded, let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else { return }
        print("Configure image: \(url)")
        posterImageView.sd_setImage(with: url) { [weak self] _, _, _, _ in
            self?.isImageLoaded = true
        }
    }
}
