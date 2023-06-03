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
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .daGreen
        view.layer.cornerRadius = 20
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
        self.titleLabel.font = .bmEuljiro(fontSize)
        layoutSubviews()
    }
    
    func setContentView(_ view: UIView){
        contentView.subviews.forEach { view in
                view.removeFromSuperview()
        }
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        layoutSubviews()
    }
    
    private func configure() {
        
    }
    
    private func addSubviews() {
        [titleLabel, contentView].forEach { view in
            self.addSubview(view)
        }
    }
    private func makeConstraints() {
        [self, titleLabel, contentView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            self.heightAnchor.constraint(equalToConstant: 120),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            contentView.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
