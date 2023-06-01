//
//  ProfileView.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import UIKit

final class ContentBoxComponentView: UIView  {
    private let title: String
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .kavoon(30)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contentBox: UIView = {
       let view = UIView()
        view.backgroundColor = 
    }()
    
    init(_ title: String) {
        super.init(frame: .zero)
        self.title = title
        configure()
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .white
        self.titleLabel.text = title
    }
    
    private func addSubviews() {
        [titleLabel].forEach { view in
            self.addSubview(view)
        }
    }
    private func makeConstraints() {
        [titleLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)

        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
