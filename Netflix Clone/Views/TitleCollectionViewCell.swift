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
        imageView.tintColor = .white
        return imageView
    }()
    
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
        
        guard !model.isEmpty, let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else {
            posterImageView.image = UIImage(systemName: "exclamationmark.circle")
            posterImageView.contentMode = .scaleAspectFit
            return
        }
        
//        print("Configure image: \(url)")
        posterImageView.sd_setImage(with: url)
        posterImageView.contentMode = .scaleAspectFill
    }
}
