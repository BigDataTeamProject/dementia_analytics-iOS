//
//  ResultPageView.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import UIKit

final class ResultPageView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bmEuljiro(24)
        label.textAlignment = .center
        label.text = StringCollection.noDataTitle
        return label
    }()
    private lazy var similarityLabel: UILabel = {
        let label = UILabel()
        label.font = .bmEuljiro(28)
        label.textAlignment = .center
        label.text = StringCollection.noDataSimilar
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .bmEuljiro(24)
        label.textAlignment = .center
        label.text = StringCollection.noDataDesc
        return label
    }()
    
    private lazy var infoLabel: UIView = {
        let label = UILabel()
        label.font = .bmEuljiro(18)
        label.textColor = .daGray
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "좌우로 스크롤하여 차트를 확인해보세요."
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
        
    }
    
    private func addSubviews() {
        [titleLabel, similarityLabel, descriptionLabel, infoLabel].forEach { view in
            self.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        [titleLabel, similarityLabel, descriptionLabel, infoLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        let constraints: [NSLayoutConstraint] = [
            similarityLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            similarityLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            similarityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                     constant: 20),
            similarityLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                      constant: -20),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                 constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: similarityLabel.topAnchor,
                                               constant: -20),
            descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                      constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                       constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: similarityLabel.bottomAnchor,
                                                  constant: 20),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                               constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                constant: -20),
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                              constant: -120)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setResult(result: DementiaType?){
        if let result = result {
            titleLabel.text = "사용자 님의"
            let similarityText = "최근 기록은 \(result.label)\(result.of)"
            let attribtuedString = NSMutableAttributedString(string: similarityText)
            let range = (similarityText as NSString).range(of: result.label)
            attribtuedString.addAttribute(.foregroundColor,
                                          value: result.color,
                                          range: range)
            similarityLabel.attributedText = attribtuedString
            descriptionLabel.text = "유사합니다."
            
        } else {
            titleLabel.text = StringCollection.noDataTitle
            similarityLabel.text = StringCollection.noDataSimilar
            descriptionLabel.text = StringCollection.noDataDesc
        }
        layoutIfNeeded()
    }
}

