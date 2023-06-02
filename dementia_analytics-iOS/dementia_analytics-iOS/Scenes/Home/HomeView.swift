//
//  HomeView.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/05/01.
//

import UIKit
import Lottie

final class HomeView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = StringCollection.title
        label.numberOfLines = 2
        label.font = .kavoon(50)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var homeButton: UIButton = {
        let button = UIButton()
        let label = UILabel()
        button.setTitle(StringCollection.startButton.uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .kavoon(30)
        button.layer.backgroundColor = UIColor.daGreen.cgColor
        button.layer.cornerRadius = 30
        return button
    }()
    
    private lazy var homeBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.homeBackground.image
        return imageView
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
        [backgroundDecorImageView, homeBackground, homeButton, titleLabel].forEach { view in
            self.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        
        [titleLabel, homeButton, homeBackground, backgroundDecorImageView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 140),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            
            homeBackground.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            homeBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            homeBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            homeBackground.heightAnchor.constraint(equalTo: homeBackground.widthAnchor,
                                                   multiplier: UIImage.homeBackground.aspectHeight),
            
            homeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            homeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            homeButton.heightAnchor.constraint(equalToConstant: 80),
            homeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -120),
            
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
