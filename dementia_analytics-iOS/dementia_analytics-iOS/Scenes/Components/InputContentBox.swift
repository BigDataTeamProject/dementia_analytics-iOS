//
//  InputContentBox.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import UIKit

final class InputContentBox: UIView  {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
    
    func setTitle(_ title: String?, fontSize: CGFloat = 22){
        self.titleLabel.text = title
        self.titleLabel.font = .bmEuljiro(fontSize)
        layoutSubviews()
    }
    
    func setContentView(_ view: UIView){
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
            self.heightAnchor.constraint(equalToConstant: 90),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            
            contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            contentView.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
