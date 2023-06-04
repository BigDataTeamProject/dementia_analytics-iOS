//
//  ChartPageViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import UIKit

class ChartPageViewController: UIViewController {
    
    private var chartPageView: ChartPageView {
        return self.view as! ChartPageView
    }
    
    override func loadView() {
        view = ChartPageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        
    }
    
    func setDataType(dataType: DADataType){
        let x = ["02-05", "03-04", "05-06", "06-01"]
        let y: [CGFloat] = [2.0, 3.0, 2.0, 2.0]
        
        let mean = DataManager.shared.mean(dataType: dataType)
        var dementiaType = DementiaType.cn
        var desc = ""
        if let recent = y.last {
            let cnDiff = fabsf(Float(recent - (mean.0 ?? 0.0)))
            let demDiff = fabsf(Float(recent - (mean.1 ?? 0.0)))
            let mciDiff = fabsf(Float(recent - (mean.2 ?? 0.0)))
            if cnDiff < demDiff && cnDiff < mciDiff {
                dementiaType = .cn
            } else if demDiff < cnDiff && demDiff < mciDiff {
                dementiaType = .dem
            } else {
                dementiaType = .mci
            }
            desc = "최근 기록은 \(dementiaType.label)의\n\(dataType.title)\(dataType.of) 유사합니다."
        }
        let attribtuedString = NSMutableAttributedString(string: desc)
        let range = (desc as NSString).range(of: dementiaType.label)
        attribtuedString.addAttribute(.foregroundColor,
                                      value: dementiaType.color,
                                      range: range)
        chartPageView.setData(title: dataType.title,
                              desc: attribtuedString,
                              x: x,
                              y: y,
                              cnAvg: 1.0,
                              demAvg: 3.0)
    }
}
