//
//  LaunchView.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/05/31.
//

import UIKit
import Lottie

final class LaunchView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = StringCollection.title
        label.numberOfLines = 2
        label.font = .bmEuljiro(50)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private var personView: LottieAnimationView = {
        let animView = LottieAnimationView(name:"person")
        animView.contentMode = .scaleAspectFill
        return animView
    }()
    
    private var decorView: LottieAnimationView = {
        let animView = LottieAnimationView(name:"decor")
        return animView
    }()
    
    lazy var teamLabel: UILabel = {
        let label = UILabel()
        label.text = StringCollection.team
        label.font = .bmEuljiro(40)
        label.textColor = .daGray
        label.textAlignment = .center
        return label
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
        [decorView,teamLabel, personView, titleLabel].forEach { view in
            self.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        
        [titleLabel, personView, teamLabel, decorView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 140),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            
            personView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            personView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            personView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            personView.heightAnchor.constraint(equalTo: personView.widthAnchor,
                                                   multiplier: UIImage.homeBackground.aspectHeight),
            
            teamLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            teamLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            teamLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
            
            decorView.widthAnchor.constraint(equalTo: self.widthAnchor),
            decorView.heightAnchor.constraint(equalTo:self.widthAnchor),
            decorView.topAnchor.constraint(equalTo: self.topAnchor),
            decorView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func animationPlay(_ completion: @escaping () -> Void){
        decorView.animationSpeed = 1.5
        personView.play{ _ in
            if !self.decorView.isAnimationPlaying {
                self.personView.removeFromSuperview()
                self.decorView.removeFromSuperview()
                completion()
            }
        }
        decorView.animationSpeed = 1.5
        decorView.play{ _ in
            if !self.personView.isAnimationPlaying {
                self.personView.removeFromSuperview()
                self.decorView.removeFromSuperview()
                completion()
            }
        }
    }
    
}
