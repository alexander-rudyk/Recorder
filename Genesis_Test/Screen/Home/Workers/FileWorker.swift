//
//  FileWorker.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import Foundation

class FileWorker {
    
    func fetchRecords() -> [Record] {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
            let directoryContrnts = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) else { return [] }
        
        
        let recordsFiles = directoryContrnts.filter { $0.pathExtension == "m4a" }
        let records = recordsFiles.compactMap { Record(path: $0) }
        
        return records.sorted(by: { $0.name > $1.name })
    }
    
    func remove(_ record: Record) {
        do {
            try FileManager.default.removeItem(at: record.path)
        } catch {
            
        }
    }
}
