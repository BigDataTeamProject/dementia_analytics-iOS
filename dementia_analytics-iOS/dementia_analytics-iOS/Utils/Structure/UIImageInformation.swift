//
//  UIImageInformation.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/05/30.
//

import UIKit

struct UIImageInformation{
    let image: UIImage
    let width: CGFloat
    let height: CGFloat
    
    var aspectWidth: CGFloat {
        return width / height
    }
    
    var aspectHeight:CGFloat {
        return height / width
    }
}
