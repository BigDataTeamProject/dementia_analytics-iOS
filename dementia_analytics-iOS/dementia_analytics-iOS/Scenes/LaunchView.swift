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
        label.font = .kavoon(50)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private var personView: LottieAnimationView = {
        let animView = LottieAnimationView(name:"person")
        return animView
    }()
    
    private var decorView: LottieAnimationView = {
        let animView = LottieAnimationView(name:"decor")
        return animView
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
        [decorView, personView, titleLabel].forEach { view in
            self.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        
        [titleLabel, personView, decorView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 180),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            
            personView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -22),
            personView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            personView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            personView.heightAnchor.constraint(equalTo: personView.widthAnchor),
            
            decorView.widthAnchor.constraint(equalTo: self.widthAnchor),
            decorView.heightAnchor.constraint(equalTo:self.widthAnchor),
            decorView.topAnchor.constraint(equalTo: self.topAnchor),
            decorView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func animationPlay(_ completion: @escaping () -> Void){
        personView.play{ _ in
            if !self.decorView.isAnimationPlaying {
                self.personView.removeFromSuperview()
                self.decorView.removeFromSuperview()
                completion()
            }
        }
        decorView.play{ _ in
            if !self.personView.isAnimationPlaying {
                self.personView.removeFromSuperview()
                self.decorView.removeFromSuperview()
                completion()
            }
        }
    }
    
}
