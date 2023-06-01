//
//  SettingsView.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import UIKit

final class SettingsView: UIView {
    
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
        [].forEach { view in
            self.addSubview(view)
        }
    }
    private func makeConstraints() {
        // [].forEach { view in
        //     view.translatesAutoresizingMaskIntoConstraints = false
        // }
        
        let constraints: [NSLayoutConstraint] = [
          
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
