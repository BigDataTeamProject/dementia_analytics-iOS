//
//  GraphView.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/05/30.
//

import UIKit

final class GraphView: UIView {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChartCollectionViewCell.self,
                                forCellWithReuseIdentifier: ChartCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var backgroundDecorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.homeBackgroundDecor.image
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        configure()
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func addSubviews() {
        [backgroundDecorImageView, collectionView].forEach { view in
            self.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        [backgroundDecorImageView, collectionView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor),
            
            backgroundDecorImageView.widthAnchor.constraint(equalTo: self.widthAnchor,
                                                            multiplier: 0.475),
            backgroundDecorImageView.heightAnchor.constraint(equalTo:backgroundDecorImageView.widthAnchor,
                                                             multiplier: UIImage.homeBackgroundDecor.aspectHeight),
            backgroundDecorImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundDecorImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
