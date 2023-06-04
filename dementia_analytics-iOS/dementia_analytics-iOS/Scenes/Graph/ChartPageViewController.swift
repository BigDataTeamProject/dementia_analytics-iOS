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
        chartPageView.setData(title: dataType.title,
                              desc: "최근 데이터는 ~와 유사합니다",
                              x: ["02-05", "03-04", "05-06"],
                              y: [2.0, 3.0, 2.0],
                              cnAvg: 1.0,
                              demAvg: 3.0)
    }
}
