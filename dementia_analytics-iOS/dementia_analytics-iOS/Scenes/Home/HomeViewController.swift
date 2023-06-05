//
//  HomeViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/05/01.
//

import UIKit
import Combine
import Moya

class HomeViewController: UIViewController {
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    private var homeView: HomeView {
        return self.view as! HomeView
    }
    
    override func loadView() {
        view =  HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        test()
    }
    
    func configure(){
        homeView.homeButton.addTarget(self, action: #selector(showManageDataView), for: .touchUpInside)
    }
    
    func test(){
        let provider = MoyaProvider<APIService>()
        // let featuresData = features.toJSON()!
        let featuresData = Features.testDataCN.toJSON()!
        provider.requestPublisher(.predict(featuresData))
            .map{ response -> Prediction? in
                print(response)
                return try? response.map(Prediction.self)
            }
            .mapError{ error in
                error as Error
            }
            .replaceError(with: nil)
            .map { pred -> DementiaType? in
                return pred?.dementiaType }
            .eraseToAnyPublisher()
            .sink { type in
                print(type)
            }
            .store(in: &cancellable)
    }
}

extension HomeViewController {
    @objc
    func showManageDataView(){
        let vc = ManageDataViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

