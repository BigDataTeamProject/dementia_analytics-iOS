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
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        let label = UILabel()
        button.setTitle(StringCollection.startButton.uppercased(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .kavoon(50)
        button.setBackgroundImage(UIImage.homeStartButtonBackground.image, for: .normal)
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
        showLaunchView()
    }
    
    private func showLaunchView(){
        let launchView: LaunchView = LaunchView()
        self.addSubview(launchView)
        launchView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints: [NSLayoutConstraint] = [
            launchView.topAnchor.constraint(equalTo: self.topAnchor),
            launchView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            launchView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            launchView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
        launchView.animationPlay {
            launchView.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .white
    }
    
    private func addSubviews() {
        [backgroundDecorImageView, homeBackground, startButton, titleLabel].forEach { view in
            self.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        
        [titleLabel, startButton, homeBackground, backgroundDecorImageView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 180),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            
            homeBackground.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            homeBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            homeBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            homeBackground.heightAnchor.constraint(equalTo: homeBackground.widthAnchor,
                                                   multiplier: UIImage.homeBackground.aspectHeight),
            
            startButton.topAnchor.constraint(equalTo: homeBackground.bottomAnchor, constant: 24),
            startButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 56),
            startButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -56),
            startButton.heightAnchor.constraint(equalTo: startButton.widthAnchor,
                                                multiplier: UIImage.homeStartButtonBackground.aspectHeight),
            
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
