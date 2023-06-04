//
//  SettingsView.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import UIKit

final class SettingsView: UIView {
    var showUpdateProfile: (()->Void)? = nil
    var moveToSetting: (()->Void)? = nil
    
    private let auth: Bool = DementiaAnalyticsModel.shared.auth
    
    private lazy var backgroundDecorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.homeBackgroundDecor.image
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var profileBox: ContentBox = {
        let contentBox = ContentBox()
        contentBox.setTitle(StringCollection.profile)
        return contentBox
    }()
    
    lazy var registerProfileButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 4, bottom: 4, trailing: 4)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let button = UIButton(configuration: config)
        button.setImage(UIImage(systemName: "square.and.pencil",
                                withConfiguration: imageConfig),
                        for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        configure()
        addSubviews()
        makeConstraints()
        setAuth()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .white
        registerProfileButton.addTarget(self,
                                        action: #selector(showUpdateProfileButton),
                                        for: .touchUpInside)
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
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 140),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
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
        contentView.tag = 10
        let label = UILabel()
        if let user = user {
            label.text = "\(user.name)님"
            label.textColor = .white
            label.font = .bmEuljiro(24)
            registerProfileButton.tintColor = .daGray
        } else {
            label.text = StringCollection.profileNotFound
            label.textColor = .daGray
            label.font = .bmEuljiro(18)
            registerProfileButton.tintColor = .white
        }
        [label, registerProfileButton].forEach { view in
            contentView.addSubview(view)
        }
        [label, registerProfileButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        let constraints: [NSLayoutConstraint] = [
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: registerProfileButton.leadingAnchor, constant: 10),
            registerProfileButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            registerProfileButton.heightAnchor.constraint(equalToConstant: 38),
            registerProfileButton.widthAnchor.constraint(equalTo: registerProfileButton.heightAnchor),
            registerProfileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ]
        NSLayoutConstraint.activate(constraints)
        profileBox.setContentView(contentView)
        layoutIfNeeded()
    }
    
    func setAuth(){
        if DementiaAnalyticsModel.shared.auth {
            let descriptionLabel = UILabel()
            descriptionLabel.text = StringCollection.daDescription
            descriptionLabel.font = .bmEuljiro(16)
            descriptionLabel.textColor = .lightGray
            descriptionLabel.numberOfLines = 3
            descriptionLabel.textAlignment = .center
            stackView.addArrangedSubview(descriptionLabel)
        } else {
            let authCheckBox = SettingContentBox()
            authCheckBox.setDescription(StringCollection.noAuth)
            authCheckBox.setButton(StringCollection.moveToSetting,
                                   symbol: "greaterthan"){ [weak self] in
                self?.moveToSettingButton()
            }
            
            stackView.addArrangedSubview(authCheckBox)
        }
        layoutSubviews()
    }
    
    @objc func showUpdateProfileButton(){
        showUpdateProfile?()
    }
    
    func moveToSettingButton(){
        moveToSetting?()
    }
}
