//
//  SettingsView.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import UIKit

final class SettingsView: UIView {
    private lazy var backgroundDecorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.homeBackgroundDecor.image
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var profileBox: ContentBox = {
        let contentBox = ContentBox()
        contentBox.setTitle("Profile")
        return contentBox
    }()
    
    private lazy var registerProfileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .white
        return button
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
        [backgroundDecorImageView, stackView].forEach { view in
            self.addSubview(view)
        }
        
        [profileBox].forEach { view in
            stackView.addArrangedSubview(view)
        }
    }
    
    private func makeConstraints() {
        [backgroundDecorImageView, stackView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 180),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            profileBox.leadingAnchor.constraint(equalTo:  stackView.leadingAnchor),
            profileBox.trailingAnchor.constraint(equalTo:  stackView.trailingAnchor),
            
            backgroundDecorImageView.widthAnchor.constraint(equalTo: self.widthAnchor,
                                                            multiplier: 0.475),
            backgroundDecorImageView.heightAnchor.constraint(equalTo:backgroundDecorImageView.widthAnchor,
                                                             multiplier: UIImage.homeBackgroundDecor.aspectHeight),
            backgroundDecorImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundDecorImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setUser(user: User?){
        let contentView = UIView()
        let label = UILabel()
        if let user = user {
            label.text = user.name
            label.textColor = .white
            label.font = .kavoon(24)
            registerProfileButton.tintColor = .daGray
        } else {
            label.text = StringCollection.profileNotFound
            label.textColor = .daGray
            label.font = .kavoon(18)
            registerProfileButton.tintColor = .white
        }
        [label, registerProfileButton].forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        let constraints: [NSLayoutConstraint] = [
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: registerProfileButton.leadingAnchor, constant: 10),
            registerProfileButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            registerProfileButton.heightAnchor.constraint(equalToConstant: 28),
            registerProfileButton.widthAnchor.constraint(equalTo: registerProfileButton.heightAnchor),
            registerProfileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ]
        NSLayoutConstraint.activate(constraints)
        profileBox.setContentView(contentView)
        layoutIfNeeded()
    }
}
