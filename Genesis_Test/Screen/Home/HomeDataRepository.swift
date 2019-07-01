//
//  HomeDataRepository.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import Foundation

protocol HomeDataRepositoryDelegate: class {
    func dataChanged(_ newData: [Record])
}

class HomeDataRepository {
    
    weak var delegate: HomeDataRepositoryDelegate?
    
    private(set) var data: [Record] = [] {
        didSet {
            delegate?.dataChanged(data)
        }
    }
    
    func set(data: [Record]) {
        self.data = data
    }
    
    func add(record: Record) {
        data.insert(record, at: 0)
    }
    
    func removeAll() {
        data.removeAll()
    }
    
    @discardableResult
    func remove(record: Record) -> Bool {
        guard let index = data.firstIndex(where: { $0 == record }) else {
            return false
        }
        
        data.remove(at: index)
        
        return true
    }
    
    @discardableResult
    func update(_ record: Record) -> Bool {
        guard let index = data.firstIndex(where: { $0 == record }) else {
            return false
        }
        
        data[index] = record
        
        return true
    }
}
