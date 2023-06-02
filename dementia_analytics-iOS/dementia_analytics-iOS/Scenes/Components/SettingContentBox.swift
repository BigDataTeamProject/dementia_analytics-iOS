//
//  SettingContentBox.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/02.
//

import UIKit

final class SettingContentBox: UIView  {
    var completion: (()->Void)? = nil
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setBackgroundColor(.daGray, for: .normal)
        button.layer.cornerRadius = 20
        button.semanticContentAttribute = .forceRightToLeft
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
    
    func setDescription(_ desc: String?, fontSize: CGFloat = 16, textColor: UIColor = .lightGray){
        self.descriptionLabel.text = desc
        self.descriptionLabel.font = .bmEuljiro(fontSize)
        self.descriptionLabel.textColor = textColor
        layoutSubviews()
    }
    
    func setButton(_ title: String,
                   symbol: String,
                   fontSize: CGFloat = 18,
                   completion: @escaping ()->Void){
        settingButton.setTitle(title, for: .normal)
        settingButton.titleLabel?.font = .bmEuljiro(fontSize)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let image = UIImage(systemName: symbol,
                            withConfiguration: imageConfig)
        settingButton.setTitleColor(.white, for: .normal)
        settingButton.setImage(image, for: .normal)
        settingButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        settingButton.layer.cornerRadius = 20
        self.completion = completion
        layoutIfNeeded()
    }
    
    private func configure() {
        
    }
    
    private func addSubviews() {
        [descriptionLabel, settingButton].forEach { view in
            self.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        [self, descriptionLabel, settingButton].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            self.heightAnchor.constraint(equalToConstant: 160),
            settingButton.topAnchor.constraint(equalTo: self.topAnchor),
            settingButton.heightAnchor.constraint(equalToConstant: 60),
            settingButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            settingButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: settingButton.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc
    func buttonAction(){
        completion?()
    }
}

