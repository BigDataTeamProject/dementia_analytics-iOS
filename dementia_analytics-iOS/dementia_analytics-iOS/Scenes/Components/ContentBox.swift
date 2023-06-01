//
//  ContentBox.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import UIKit

final class ContentBox: UIView  {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var contentBox: UIView = {
        let view = UIView()
        // view.layer.
        view.backgroundColor = .daGreen
        view.layer.cornerRadius = 30
        return view
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
    
    func setTitle(_ title: String?, fontSize: CGFloat = 30){
        self.titleLabel.text = title
        self.titleLabel.font = .kavoon(fontSize)
        layoutSubviews()
    }
    
    func setContentView(_ view: UIView){
        self.contentBox = view
        layoutSubviews()
    }
    
    private func configure() {
        
    }
    
    private func addSubviews() {
        [titleLabel, contentBox].forEach { view in
            self.addSubview(view)
        }
    }
    private func makeConstraints() {
        [titleLabel, contentBox].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            contentBox.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            contentBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            contentBox.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            contentBox.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
