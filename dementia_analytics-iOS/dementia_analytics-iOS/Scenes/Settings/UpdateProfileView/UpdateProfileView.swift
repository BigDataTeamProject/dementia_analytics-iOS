//
//  UpdateProfileView.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/02.
//

import UIKit

final class UpdateProfileView: UIView {
    private lazy var backgroundDecorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.homeBackgroundDecor.image
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 30, leading: 0, bottom: 30, trailing: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.backgroundColor = UIColor.daGreen.cgColor
        stackView.layer.cornerRadius = 30
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var nameBox: InputContentBox = {
        let contentBox = InputContentBox()
        contentBox.setTitle(StringCollection.name, fontSize: 20)
        return contentBox
    }()
    
    private lazy var ageBox: InputContentBox = {
        let contentBox = InputContentBox()
        contentBox.setTitle(StringCollection.age, fontSize: 20)
        return contentBox
    }()
    
    private lazy var heightBox: InputContentBox = {
        let contentBox = InputContentBox()
        contentBox.setTitle(StringCollection.height, fontSize: 20)
        return contentBox
    }()
    
    private lazy var weightBox: InputContentBox = {
        let contentBox = InputContentBox()
        contentBox.setTitle(StringCollection.weight, fontSize: 20)
        return contentBox
    }()
    
    private lazy var storeButton: UIButton = {
        let button = UIButton()
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(.daGreen, for: .normal)
        button.setTitle(StringCollection.store, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .bmEuljiro(20)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(.daRed, for: .normal)
        button.setTitle(StringCollection.cancel, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .bmEuljiro(20)
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
        [backgroundDecorImageView, scrollView].forEach { view in
            self.addSubview(view)
        }
        
        [nameBox, ageBox, heightBox, weightBox].forEach { view in
            inputStackView.addArrangedSubview(view)
        }
        
        [storeButton, cancelButton].forEach { view in
            buttonStackView.addArrangedSubview(view)
        }
        
        [inputStackView, buttonStackView].forEach { view in
            stackView.addArrangedSubview(view)
        }
        
        [stackView].forEach { view in
            scrollView.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        [backgroundDecorImageView, scrollView, stackView,inputStackView, nameBox, ageBox].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let stackViewHeightAnchor = stackView.widthAnchor.constraint(equalTo: scrollView.heightAnchor)
        stackViewHeightAnchor.priority = .defaultLow
        
        let constraints: [NSLayoutConstraint] = [
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            inputStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            inputStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            
            buttonStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            storeButton.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor, constant: 24),
            storeButton.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor, constant: -24),
            storeButton.heightAnchor.constraint(equalToConstant: 60),
            
            cancelButton.leadingAnchor.constraint(equalTo: buttonStackView.leadingAnchor, constant: 24),
            cancelButton.trailingAnchor.constraint(equalTo: buttonStackView.trailingAnchor, constant: -24),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            nameBox.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor),
            nameBox.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor),
            ageBox.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor),
            ageBox.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor),
            heightBox.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor),
            heightBox.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor),
            weightBox.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor),
            weightBox.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor),
            
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
