//
//  TestView.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/05/30.
//

import UIKit

final class TestView: UIView {
    private lazy var backgroundDecorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.homeBackgroundDecor.image
        return imageView
    }()
    
    private lazy var agePicker: NumberPicker = {
        let numberPicker = NumberPicker()
        numberPicker.maxValue = 100
        return numberPicker
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
        [backgroundDecorImageView, agePicker].forEach { view in
            self.addSubview(view)
        }
    }
    
    private func makeConstraints() {
        [backgroundDecorImageView, agePicker].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            agePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            agePicker.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            agePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            agePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
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
