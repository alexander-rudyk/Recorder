//
//  HomeUIInitializer.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import UIKit
import SnapKit

class HomeUIInitializer: IInitializer {
    
    private unowned var controller: HomeViewController
    
    init(with vc: HomeViewController) {
        controller = vc
    }
    
    func initialize() {
        addRecordingButton()
//        addEditButton()
        addTableView()
    }
    
    //MARK: - Private
    
    private func addRecordingButton() {
        let recordingButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        
        controller.navigationItem.rightBarButtonItem = recordingButton
    }
    
    private func addEditButton() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
        
        controller.navigationItem.leftBarButtonItem = editButton
    }
    
    private func addTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        
        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.description())
        
        controller.view.addSubview(tableView)
        controller.tableView = tableView
        
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
