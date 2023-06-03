//
//  ManageDataViewController.swift
//  dementia_analytics-iOS
//
//  Created by 이전희 on 2023/06/03.
//

import UIKit
import FSCalendar

class ManageDataViewController: UIViewController {

    private var manageDataView: ManageDataView {
        return self.view as! ManageDataView
    }
    
    override func loadView() {
        view =  ManageDataView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        self.manageDataView.tableView.delegate = self
        self.manageDataView.tableView.dataSource = self
        self.manageDataView.calendar.delegate = self
        self.manageDataView.calendar.dataSource = self
    }
}

extension ManageDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension ManageDataViewController: FSCalendarDelegate, FSCalendarDataSource{
    
}
