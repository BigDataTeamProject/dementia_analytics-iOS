//
//  ResultPageViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/04.
//

import UIKit
import Combine
import Moya

class ResultPageViewController: UIViewController {
    private let dataManager = DataManager.shared
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private var resultPageView: ResultPageView {
        return self.view as! ResultPageView
    }
    
    override func loadView() {
        view = ResultPageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        predict()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func predict(){
        guard let feturesData = dataManager.features() else { return }
        let provider = MoyaProvider<APIService>()
        return provider.requestPublisher(.predict(feturesData))
            .receive(on: DispatchQueue.main)
            .map{ response -> Prediction? in
                print(response)
                return try? response.map(Prediction.self)
            }
            .replaceError(with: nil)
            .map { pred -> DementiaType? in
                return pred?.dementiaType }
            .sink (receiveValue: { type in
                DispatchQueue.main.async {
                    self.resultPageView.setResult(result: type)
                }
            })
            .store(in: &cancellable)
    }
    
}
