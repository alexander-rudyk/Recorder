//
//  HomeViewController.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

protocol HomeDisplayLogic: class {
    func showError(message: String)
    func showItems(records: [Record])
}

class HomeViewController: BaseViewController {
    
    private var recordsObserver: BehaviorSubject<[Record]>!
    private var disposeBag = DisposeBag()
    
    var interactor: HomeInteractor!
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Records"
        
        interactor.fetchRecords()
        
        subscribeTableView()
        subscribeToAddButton()
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView?.setEditing(editing, animated: animated)
    }
    
    //MARK: - Private
    
    private lazy var playButtonAction: (Record?) -> () = { [weak self] record in
        guard let record = record else { return }
        self?.interactor.selected(record)
    }
    
    private func subscribeToAddButton() {
        guard let addButton = navigationItem.rightBarButtonItem else { return }
        
        addButton.rx.tap
            .bind { [weak self] _ in
                self?.interactor.isRecording ?? false ?
                    self?.interactor.finishRecording() :
                    self?.interactor.startRecording()
                
            }
            .disposed(by: disposeBag)
    }
    
    private func subscribeTableView() {
        recordsObserver
            .bind(to: tableView.rx.items(cellIdentifier: RecordTableViewCell.description(), cellType: RecordTableViewCell.self)) { [weak self] (row, element, cell) in
                
                cell.configure(with: element)
                cell.playButtonAction = self?.playButtonAction
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(Record.self)
            .subscribe(onNext: { [weak self] value in
                // Open detail Screan
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelDeleted(Record.self)
            .subscribe(onNext: { [weak self] value in
                self?.interactor.remove(record: value)
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
}

//MARK: - RecordWorkerDelegate
extension HomeViewController: HomeDisplayLogic {
    func showError(message: String) {
        // Show alert
    }
    
    func showItems(records: [Record]) {
        if recordsObserver == nil {
            recordsObserver = BehaviorSubject<[Record]>(value: records)
        } else {
            recordsObserver.onNext(records)
        }
    }
}
