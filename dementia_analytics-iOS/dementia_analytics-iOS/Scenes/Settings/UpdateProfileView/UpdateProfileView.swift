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
        return stackView
    }()
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var nameBox: ContentBox = {
        let contentBox = ContentBox()
        contentBox.setTitle("Profile")
        return contentBox
    }()
    
    private lazy var ageBox: ContentBox = {
        let contentBox = ContentBox()
        contentBox.setTitle("aaa")
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
        [backgroundDecorImageView, scrollView].forEach { view in
            self.addSubview(view)
        }
        
        [nameBox, ageBox].forEach { view in
            inputStackView.addArrangedSubview(view)
        }
        
        [inputStackView].forEach { view in
            stackView.addArrangedSubview(view)
        }
        
        // [ageBox].forEach { view in
        //     stackView.addArrangedSubview(view)
        // }
        [stackView].forEach { view in
            scrollView.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        [backgroundDecorImageView, scrollView, stackView, nameBox, ageBox].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let stackViewHeightAnchor = stackView.widthAnchor.constraint(equalTo: scrollView.heightAnchor)
        stackViewHeightAnchor.priority = .defaultLow
        
        let constraints: [NSLayoutConstraint] = [
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            

            inputStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            inputStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            nameBox.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor),
            nameBox.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor),
            ageBox.leadingAnchor.constraint(equalTo: inputStackView.leadingAnchor),
            ageBox.trailingAnchor.constraint(equalTo: inputStackView.trailingAnchor),
           
            
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
