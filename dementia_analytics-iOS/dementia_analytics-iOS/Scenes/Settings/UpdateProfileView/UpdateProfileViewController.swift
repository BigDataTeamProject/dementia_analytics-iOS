//
//  UpdateProfileViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/02.
//

import UIKit
import Combine
import CoreDataStorage

class UpdateProfileViewController: UIViewController {
    private var user: User? = nil
    private let storage = CoreDataStorage.shared(name: "DementiaDataStorage")
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private var updateProfileView: UpdateProfileView {
        return self.view as! UpdateProfileView
    }
    
    override func loadView() {
        view = UpdateProfileView()
    }
    
    init(user:User?) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
