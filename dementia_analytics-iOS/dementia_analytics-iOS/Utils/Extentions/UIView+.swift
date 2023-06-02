//
//  UIView+.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/02.
//

import UIKit

extension UIView {
    public func addShadow(color: UIColor,
                                offset: CGSize,
                                radius: CGFloat,
                         opacity: Float) {
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
}
