//
//  StoreDataView.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/05.
//

import UIKit
import FSCalendar

final class StoreDataView: UIView {
    private lazy var backgroundDecorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.homeBackgroundDecor.image
        return imageView
    }()
    
    lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.headerTitleFont = .bmEuljiro(20)
        calendar.appearance.weekdayFont = .bmEuljiro(18)
        calendar.appearance.titleFont = .bmEuljiro(18)
        calendar.appearance.headerTitleColor = .daGreen
        calendar.appearance.weekdayTextColor = .daGreen
        calendar.appearance.eventDefaultColor = .daRed
        calendar.appearance.eventSelectionColor = .daRed
        return calendar
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(DataCollectionViewCell.self,
                                forCellWithReuseIdentifier: DataCollectionViewCell.identifier)
        return collectionView
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
        [backgroundDecorImageView, collectionView, calendar].forEach { view in
            self.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        
        [backgroundDecorImageView, collectionView, calendar].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            calendar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            calendar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            calendar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            calendar.heightAnchor.constraint(lessThanOrEqualToConstant: 400),
            
            collectionView.topAnchor.constraint(equalTo: calendar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
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
