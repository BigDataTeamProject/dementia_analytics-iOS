//
//  GraphViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/01.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    
    private var testView: GraphView {
        return self.view as! GraphView
    }
    
    override func loadView() {
        view =  GraphView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
